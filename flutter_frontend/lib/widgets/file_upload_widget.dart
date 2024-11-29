import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatelessWidget {
  final bool isDragging;
  // final File? selectedFile;
  final VoidCallback pickFile;

  const FileUploadWidget({
    Key? key,
    required this.isDragging,
    // required this.selectedFile,
    required this.pickFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDragging
            ? Colors.blue.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload,
            size: 48,
            color: isDragging ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 16),
          // Text(
          //   selectedFile != null
          //       ? 'Selected: ${selectedFile!.path.split('/').last}'
          //       : 'Drag and drop files here or click to select',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: isDragging ? Colors.blue : Colors.grey,
          //   ),
          // ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: pickFile,
            child: const Text('Select File'),
          ),
        ],
      ),
    );
  }
}
