import 'package:flutter/material.dart';

class ConvertButton extends StatelessWidget {
  final bool isUploading;
  final VoidCallback onPressed;

  const ConvertButton({
    super.key,
    required this.isUploading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: isUploading ? null : onPressed,
      child: isUploading
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
    );
  }
}
