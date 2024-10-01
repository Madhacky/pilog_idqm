import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart'; // For picking files
import 'package:path_provider/path_provider.dart'; // To get device storage paths
import 'dart:io';  // To save the file
import 'package:open_file/open_file.dart'; // To open the file

class UploadAndDownloadPdfScreen extends StatefulWidget {
  @override
  _UploadAndDownloadPdfScreenState createState() => _UploadAndDownloadPdfScreenState();
}

class _UploadAndDownloadPdfScreenState extends State<UploadAndDownloadPdfScreen> {
  final Dio _dio = Dio();

  Future<void> _uploadAndDownloadPdf() async {
    try {
      // Step 1: Pick PDF file from the device
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;

        // Step 2: Create FormData to send the PDF file
        FormData formData = FormData.fromMap({
          'fileName': await MultipartFile.fromFile(filePath, filename: fileName),
        });

        // Step 3: Upload the file and receive the PDF response
        final response = await _dio.post(
          'http://apihub.pilogcloud.com:6673/edit_pdf',
          data: formData,
          options: Options(
            responseType: ResponseType.bytes,  // Ensure the response is in bytes
            headers: {
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        if (response.statusCode == 200) {
          // Step 4: Get a directory to save the PDF file
          Directory? appDocDir = await getExternalStorageDirectory();
          String savePath = '${appDocDir!.path}/edited_${DateTime.now().millisecondsSinceEpoch}.pdf';

          // Step 5: Save the PDF to the device
          File file = File(savePath);
          await file.writeAsBytes(response.data);  // Write the bytes to a file

          print('File saved at: $savePath');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF saved at $savePath')),
          );

          // Step 6: Open the PDF file
          OpenFile.open(savePath);
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        print('File selection was canceled.');
      }
    } catch (e) {
      print('Error uploading or downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Optical Character Recognition'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _uploadAndDownloadPdf,
          child: Text('Upload PDF'),
        ),
      ),
    );
  }
}
