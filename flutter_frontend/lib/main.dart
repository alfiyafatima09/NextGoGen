import 'package:flutter/material.dart';
import 'screens/file_upload_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FileUploadPage(),
    );
  }
}


// // ignore_for_file: avoid_print

// import 'dart:convert';
// import 'dart:io' as io;
// import 'dart:typed_data';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';

// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_frontend/json_formater.dart';
// import 'package:http/http.dart' as http;
// import 'dart:html' as html;
// import 'package:universal_html/html.dart' hide Text;
// import 'package:dotted_border/dotted_border.dart';

// void main() {
//   runApp(MyApp());
// }

// Map _formatJson(jsonString) {
//   const JsonEncoder encoder = JsonEncoder.withIndent('  ');
//   final dynamic jsonObject = json.decode(jsonString);
//   return jsonObject;
//   // if (jsonObject is Map) {
//   //   print(jsonObject);
//   //   return jsonObject;
//   // } else if (jsonObject is List) {
//   //   return {'data': jsonObject};
//   // } else {
//   //   throw Exception('Invalid JSON format');
//   // }
//   // return encoder.convert(jsonObject);
// }

// class MyApp extends StatelessWidget {
//   MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'File Upload Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: const FileUploadScreen(),
//     );
//   }
// }

// class FileUploadScreen extends StatefulWidget {
//   const FileUploadScreen({Key? key}) : super(key: key);

//   @override
//   State<FileUploadScreen> createState() => _FileUploadScreenState();
// }

// class _FileUploadScreenState extends State<FileUploadScreen> {
//   PlatformFile? _selectedFile;
//   bool _isDragging = false;
//   bool _isUploading = false;
//   bool uploadedDone = false;
//   var data = {};

//   // Initialize drag and drop for web
//   void _initializeDragDrop(BuildContext context) {
//     // Only initialize if running on web
//     if (identical(0, 0.0)) return;

//     final dropZone = html.document.getElementById('dropZone');
//     if (dropZone != null) {
//       dropZone.onDragOver.listen((event) {
//         event.preventDefault();
//         setState(() => _isDragging = true);
//       });

//       dropZone.onDragLeave.listen((event) {
//         event.preventDefault();
//         setState(() => _isDragging = false);
//       });

//       dropZone.onDrop.listen((event) {
//         event.preventDefault();
//         setState(() => _isDragging = false);
//         final files = event.dataTransfer?.files;
//         if (files != null && files.isNotEmpty) {
//           _handleFileSelection(files.first);
//         }
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeDragDrop(context);
//     });
//   }

//   void _handleFileSelection(dynamic file) {
//     if (file != null) {
//       setState(() {
//         _selectedFile = PlatformFile(
//           name: file.name,
//           size: file.size,
//           path: file.path,
//         );
//       });
//     }
//   }

//   Future<void> _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.any,
//       allowMultiple: false,
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.first;
//       });
//     }
//   }

//   Future<void> _saveFile(Uint8List bytes, String fileName) async {
//     try {
//       final filePath = '$fileName';

//       final file = io.File(filePath);

//       // Write the file
//       await file.writeAsBytes(bytes);
//       print('File downloaded to $filePath');

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('File downloaded to $filePath')),
//       );
//     } catch (e) {
//       print('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving file: $e')),
//       );
//     }
//   }

//   Future<void> _uploadFile() async {
//     if (_selectedFile == null) return;

//     setState(() => _isUploading = true);

//     try {
//       // Replace with your backend URL
//       final url = Uri.parse('http://localhost:8000/toJson');
//       // print(_selectedFile!.path!.replaceAll('/Volumes/chetan/', ''));
//       // print(json.encoder.convert({
//       //   "filePath": _selectedFile!.path!.replaceAll('/Volumes/chetan/', '')
//       // }));
//       final response = await http.post(url,
//           headers: {
//             'Content-Type': 'application/json',
//             "Access-Control-Allow-Origin": "*",
//             "Access-Control-Allow-Methods": "POST, GET",
//           },
//           body: json.encoder.convert({
//             "filePath": _selectedFile!.path!.replaceAll('/Volumes/chetan', '')
//           }));
//       //   },
//       // );
//       // if (response.statusCode == 200) {
//       var x = json.decode(response.body);
//       print(x['data']['outputPath']);
//       final bytes = base64Decode(x['data']['outputPath']);
//       print(bytes);
//       await _saveFile(bytes, _selectedFile!.name);
//       return;
//       // final filePath = '/Users/chetanr/Downloads/${_selectedFile!.name}';
//       // final file = File(filePath);
//       // await file.writeAsBytes(bytes);
//       // print('File downloaded to $filePath');
//       // print(x);
//       // setState(() {
//       //   data = _formatJson(response.body);
//       // });
//       // setState(() {
//       //   uploadedDone = true;
//       // });
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('File uploaded successfully!')),
//       // );
//       // // } else {
//       // //   print(response.body);
//       // //   throw Exception('Failed to upload file');
//       // }
//     } catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading file: $e')),
//       );
//     } finally {
//       setState(() => _isUploading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var data = {};
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('File Upload Demo'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               if (!uploadedDone)
//                 DottedBorder(
//                   borderType: BorderType.RRect,
//                   radius: const Radius.circular(12),
//                   color: _isDragging ? Colors.blue : Colors.grey,
//                   strokeWidth: 2,
//                   dashPattern: const [8, 4],
//                   child: Container(
//                     width: double.infinity,
//                     height: 200,
//                     decoration: BoxDecoration(
//                       color: _isDragging
//                           ? Colors.blue.withOpacity(0.1)
//                           : Colors.grey.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.cloud_upload,
//                           size: 48,
//                           color: _isDragging ? Colors.blue : Colors.grey,
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           _selectedFile != null
//                               ? 'Selected: ${_selectedFile!.name}'
//                               : 'Drag and drop files here or click to select',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: _isDragging ? Colors.blue : Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: _pickFile,
//                           child: const Text('Select File'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 24),
//               if (uploadedDone)
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         offset: const Offset(0, 5),
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                       child: JsonViewer(
//                     jsonData: data,
//                   )),
//                 ),
//               if (_selectedFile != null)
//                 ElevatedButton(
//                   onPressed: _isUploading ? null : _uploadFile,
//                   child: _isUploading
//                       ? const CircularProgressIndicator()
//                       : const Text('Upload File'),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
