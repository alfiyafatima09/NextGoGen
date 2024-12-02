import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../widgets/file_upload_widget.dart';
import '../../widgets/convert_button.dart';

class UploaderScreen extends StatelessWidget {
  final bool isDragging;
  final PlatformFile? selectedFile;
  final bool isUploading;
  final Function pickFile;
  final Function onConvert;

  const UploaderScreen({
    super.key,
    required this.isDragging,
    required this.selectedFile,
    required this.isUploading,
    required this.pickFile,
    required this.onConvert,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FileUploadWidget(
            isDragging: isDragging,
            pickFile: pickFile,
            selectedFileName: selectedFile?.name,
          ),
          const SizedBox(height: 24),
          if (selectedFile != null)
            ConvertButton(
              isUploading: isUploading,
              onPressed: () => onConvert(),
            ),
        ],
      ),
    );
  }
}
