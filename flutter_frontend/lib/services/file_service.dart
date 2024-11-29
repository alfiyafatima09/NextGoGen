import 'dart:io';
// import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_frontend/consts.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
// import 'dart:html' as html;

class FileService {
  static Future<http.Response> uploadFile(PlatformFile file) async {
    final url = Uri.parse(backendUrlEndpoint);
    return await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*",
        },
        body: json.encoder.convert(
            {"filePath": file.path!.replaceAll('/Volumes/chetan/', '')}));
  }

  // static void downloadFile(Uint8List bytes, String fileName) {
  //   final blob = html.Blob([bytes]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute("download", fileName)
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }
}

Future<void> sendFile(PlatformFile file) async {
  List<int> fileBytes = file.bytes!;
  String base64File = base64Encode(fileBytes);
  print(base64File);

  // Create the JSON payload
  var payload = jsonEncode({
    'fileData': base64File,
    'extension': file.extension,
    'fileName': file.name,
  });
  var response = await http.post(
    Uri.parse(backendUrlEndpoint),
    headers: {'Content-Type': 'application/json'},
    body: payload,
  );

  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('File upload failed');
  }
}
