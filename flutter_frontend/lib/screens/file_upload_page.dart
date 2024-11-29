// import 'dart:convert';
// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/file_service.dart';
import 'package:flutter_frontend/widgets/file_upload_widget.dart';

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool _isUploading = false;
  PlatformFile? selectedFile;
  bool _isDragging = false;

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          selectedFile = result.files.first;
        });
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }
  // FileData _fileData = FileData();

  // Future<File> pickFile() async {
  //   return Files.filePicker(
  //       fileData: _fileData,
  //       onSelected: (fileData) {
  //         print(fileData);
  //         _fileData = fileData;
  //       });
  // }

  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.any,
  //     allowMultiple: false,
  //   );
  //   result!.files.first;
  //   if (result != null) {
  //     setState(() {
  //       _selectedFile = File(result.files.first.path!);
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  // Future<void> _uploadFile() async {
  //   if (_selectedFile == null) return;

  //   setState(() => _isUploading = true);

  //   try {
  //     final response = await FileService.uploadFile(_selectedFile!);

  //     if (response.statusCode == 200) {
  //       final bytes = base64Decode(response.body);
  //       FileService.downloadFile(bytes, _selectedFile!.name);
  //     } else {
  //       throw Exception('Failed to upload file');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error uploading file: $e')),
  //     );
  //   } finally {
  //     setState(() => _isUploading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                selectedFile = null;
                // _fileData = FileData();
              });
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FileUploadWidget(
              isDragging: _isDragging,
              // selectedFile: ,
              pickFile: pickFile,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                sendFile(selectedFile!);
              },
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
