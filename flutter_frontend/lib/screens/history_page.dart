import 'package:flutter/material.dart';
import '../models/file_history.dart';
import '../services/history_service.dart';
import '../utils/utils.dart';

class HistoryPage extends StatelessWidget {
  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear History'),
                  content:
                      const Text('Are you sure you want to clear all history?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('Clear'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await _historyService.clearHistory();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('History cleared')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<FileHistory>>(
        future: _historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No upload history available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return ListTile(
                leading: Icon(
                  item.isSuccess ? Icons.check_circle : Icons.error,
                  color: item.isSuccess ? Colors.green : Colors.red,
                ),
                title: Text(item.fileName),
                subtitle: Text(
                  '${item.fileType.toUpperCase()} • ${formatDateTime(item.uploadDate)}',
                ),
                trailing: Icon(getFileTypeIcon(item.fileType)),
              );
            },
          );
        },
      ),
    );
  }

  IconData getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'xml':
        return Icons.code;
      case 'csv':
        return Icons.table_chart;
      case 'sql':
        return Icons.storage;
      default:
        return Icons.insert_drive_file;
    }
  }
}
