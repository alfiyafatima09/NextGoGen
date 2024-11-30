String formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return 'Today ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else if (difference.inDays == 1) {
    return 'Yesterday ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  } else {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
