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
}

Future<Map<String, dynamic>> sendFile(PlatformFile file) async {
  // For web platform, use file.bytes
  // For desktop/mobile, use file.path to read file
  List<int> fileBytes;
  if (file.bytes != null) {
    fileBytes = file.bytes!;
  } else if (file.path != null) {
    fileBytes = await File(file.path!).readAsBytes();
  } else {
    throw Exception('Invalid file: No content available');
  }

  String base64File = base64Encode(fileBytes);

  var payload = jsonEncode({
    'fileData': base64File,
    'extension': file.extension ?? '',
    'fileName': file.name,
  });

  try {
    var response = await http.post(
      Uri.parse(backendUrlEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: payload,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['data'] == null ||
          responseBody['data']['outputPath'] == null) {
        throw Exception('Invalid response format from server');
      }
      var jsonData = base64Decode(responseBody['data']['outputPath']);
      return jsonDecode(utf8.decode(jsonData));
    } else {
      throw Exception('Failed to convert file: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error processing file: $e');
  }
}
