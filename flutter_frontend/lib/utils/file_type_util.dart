import 'package:flutter/material.dart';

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
