// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/screens/JsonView/json_formater.dart';
import 'package:flutter_frontend/models/file_history.dart';
import 'package:flutter_frontend/screens/history/history_screen.dart';
import 'package:flutter_frontend/screens/uploader/uploader_screen.dart';
import 'package:flutter_frontend/services/file_service.dart';
import 'package:flutter_frontend/utils/snackbar_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool isUploading = false;
  PlatformFile? selectedFile;
  bool isDragging = false;
  List<FileHistory> _history = [];

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

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      SnackbarUtils.showError(context, 'Error picking file: $e');
    }
  }

  Future<void> handleConvert() async {
    if (selectedFile == null) {
      SnackbarUtils.showError(context, 'Please select a file first');
      return;
    }

    try {
      final response = await sendFile(selectedFile!);
      await _saveHistory(FileHistory(
        fileName: selectedFile!.name,
        fileType: selectedFile!.extension ?? 'unknown',
        uploadDate: DateTime.now(),
        isSuccess: true,
      ));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => JsonViewer(
              initiallyExpanded: true,
              jsonData: json.decode(
                  const JsonEncoder.withIndent('  ').convert(response)))));
      SnackbarUtils.showSuccess(context, 'File converted successfully');
    } catch (e) {
      SnackbarUtils.showError(context, e.toString());
      await _saveHistory(FileHistory(
        fileName: selectedFile!.name,
        fileType: selectedFile!.extension ?? 'unknown',
        uploadDate: DateTime.now(),
        isSuccess: false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:
            const Text('File Converter', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: UploaderScreen(
          isDragging: isDragging,
          selectedFile: selectedFile,
          isUploading: isUploading,
          pickFile: pickFile,
          onConvert: handleConvert,
        ),
      ),
    );
  }
}
