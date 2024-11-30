class FileHistory {
  final String fileName;
  final String fileType;
  final DateTime uploadDate;
  final bool isSuccess;

  FileHistory({
    required this.fileName,
    required this.fileType,
    required this.uploadDate,
    required this.isSuccess,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fileType': fileType,
        'uploadDate': uploadDate.toIso8601String(),
        'isSuccess': isSuccess,
      };

  factory FileHistory.fromJson(Map<String, dynamic> json) => FileHistory(
        fileName: json['fileName'],
        fileType: json['fileType'],
        uploadDate: DateTime.parse(json['uploadDate']),
        isSuccess: json['isSuccess'],
      );
}
