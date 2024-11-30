import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/json_formater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/file_history.dart';
import '../widgets/file_upload_widget.dart';
import '../services/file_service.dart';
import '../utils/json_formatter.dart';
import 'package:flutter_share/flutter_share.dart';
import '../utils/snackbar_utils.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool _isUploading = false;
  PlatformFile? selectedFile;
  bool _isDragging = false;
  List<FileHistory> _history = [];
  bool _showHistory = false;
  String? _jsonResponse;
  bool _showJsonView = false;

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
          _jsonResponse = null;
        });
      }
    } catch (e) {
      SnackbarUtils.showError(context, 'Error picking file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('file_history') ?? [];
    setState(() {
      _history = historyJson
          .map((item) => FileHistory.fromJson(json.decode(item)))
          .toList();
    });
  }

  Future<void> _saveHistory(FileHistory entry) async {
    final prefs = await SharedPreferences.getInstance();
    _history.insert(0, entry);
    if (_history.length > 15) {
      _history = _history.sublist(0, 15);
    }
    await prefs.setStringList(
      'file_history',
      _history.map((item) => json.encode(item.toJson())).toList(),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showJsonView ? 'JSON Response' : 'File Converter',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: _showJsonView
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showJsonView = false;
                  });
                },
              )
            : null,
        actions: [
          if (!_showJsonView)
            IconButton(
              icon: Icon(_showHistory ? Icons.upload_file : Icons.history,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  _showHistory = !_showHistory;
                });
              },
            ),
        ],
      ),
      body: _showJsonView
          ? _buildFullScreenJsonViewer()
          : Center(
              child: Container(
                child: _showHistory ? _buildHistory() : _buildUploader(),
              ),
            ),
    );
  }

  Widget _buildUploader() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FileUploadWidget(
              isDragging: _isDragging,
              pickFile: pickFile,
              selectedFileName: selectedFile?.name,
            ),
            const SizedBox(height: 24),
            if (selectedFile != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isUploading
                    ? null
                    : () async {
                        if (selectedFile == null) {
                          SnackbarUtils.showError(
                              context, 'Please select a file first');
                          return;
                        }

                        setState(() {
                          _isUploading = true;
                          _jsonResponse = null;
                        });

                        try {
                          final response = await sendFile(selectedFile!);
                          setState(() {
                            _jsonResponse = JsonFormatter.prettyJson(response);
                            _isUploading = false;
                            _showJsonView = true;
                          });
                          await _saveHistory(FileHistory(
                            fileName: selectedFile!.name,
                            fileType: selectedFile!.extension ?? 'unknown',
                            uploadDate: DateTime.now(),
                            isSuccess: true,
                          ));
                          SnackbarUtils.showSuccess(
                              context, 'File converted successfully');
                        } catch (e) {
                          setState(() {
                            _isUploading = false;
                          });
                          SnackbarUtils.showError(context, e.toString());
                          await _saveHistory(FileHistory(
                            fileName: selectedFile!.name,
                            fileType: selectedFile!.extension ?? 'unknown',
                            uploadDate: DateTime.now(),
                            isSuccess: false,
                          ));
                        }
                      },
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Convert File',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullScreenJsonViewer() {
    return JsonViewer(
      jsonData: _jsonResponse,
      initiallyExpanded: true,
    );
    return Container(
      color: Colors.grey[900],
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedFile?.name ?? 'JSON Response',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.white),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _jsonResponse!));
                    SnackbarUtils.showSuccess(context, 'Copied to clipboard');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _jsonResponse!,
                    style: TextStyle(
                      color: Colors.green[300],
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    if (_history.isEmpty) {
      return const Center(
        child: Text(
          'No conversion history',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
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
              '${item.fileType.toUpperCase()} • ${_formatDate(item.uploadDate)}',
            ),
            trailing: Icon(_getFileTypeIcon(item.fileType)),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getFileTypeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'xml':
        return Icons.code;
      case 'csv':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }
}
