import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/consts.dart';
import 'package:flutter_frontend/models/file_history.dart';
import 'package:flutter_frontend/services/history_service.dart';
import 'package:flutter_frontend/utils/file_upload_util.dart';
import 'package:flutter_frontend/utils/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  List<FileHistory> _history = [];
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(historyStorageKey) ?? [];
    setState(() {
      _history = historyJson
          .map((item) => FileHistory.fromJson(json.decode(item)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Upload History', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
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
              Navigator.of(context).pop();
              if (confirmed == true) {
                await _historyService.clearHistory();
                SnackbarUtils.showSuccess(context, 'History cleared');
              }
            },
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(
              child: Text(
                'No conversion history',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      item.isSuccess ? Icons.check_circle : Icons.error,
                      color: item.isSuccess ? Colors.green : Colors.red,
                    ),
                    title: Text(item.fileName),
                    subtitle: Text(
                      '${item.fileType.toUpperCase()} • ${formatDate(item.uploadDate)}',
                    ),
                    trailing: Icon(getFileTypeIcon(item.fileType)),
                  ),
                );
              },
            ),
    );
  }
}
