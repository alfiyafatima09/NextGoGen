import 'package:flutter/material.dart';

String formatDate(DateTime date) {
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

IconData getFileTypeIcon(String fileType) {
  switch (fileType.toLowerCase()) {
    case 'xml':
      return Icons.code;
    case 'csv':
      return Icons.table_chart;
    default:
      return Icons.insert_drive_file;
  }
}
