import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class FileUploadWidget extends StatelessWidget {
  final bool isDragging;
  final Function pickFile;
  final String? selectedFileName;

  const FileUploadWidget({
    Key? key,
    required this.isDragging,
    required this.pickFile,
    this.selectedFileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width * 0.8,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        dashPattern: const [10, 10],
        color: isDragging ? Colors.blue : Colors.grey,
        strokeWidth: 2,
        child: Container(
          decoration: BoxDecoration(
            color: isDragging
                ? Colors.blue.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 80,
                color: isDragging ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                selectedFileName ?? 'Drag and drop or click to select file',
                style: TextStyle(
                  fontSize: 18,
                  color: isDragging ? Colors.blue : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () => pickFile(),
                child: const Text(
                  'Select File',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
