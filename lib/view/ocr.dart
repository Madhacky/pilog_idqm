import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart' as getx;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FilePickerPreviewWidget extends StatefulWidget {
  final String apiUrl;
  final bool authToken;

  const FilePickerPreviewWidget({
    Key? key,
    required this.apiUrl,
    this.authToken = false,
  }) : super(key: key);

  @override
  _FilePickerPreviewWidgetState createState() => _FilePickerPreviewWidgetState();
}

class _FilePickerPreviewWidgetState extends State<FilePickerPreviewWidget> {
  File? _file;
  final getx.RxDouble _uploadProgress = 0.0.obs;
  bool _isUploading = false;
  List<String> _extractedTextLines = [];
  List<bool> _selectedLines = [];
  bool _isExtracting = false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
        _extractedTextLines = [];
        _selectedLines = [];
      });
    }
  }

  Future<void> _extractText() async {
    if (_file == null) return;

    setState(() {
      _isExtracting = true;
    });

    try {
      String extractedText;
      if (_file!.path.toLowerCase().endsWith('.pdf')) {
        PdfDocument document = PdfDocument(inputBytes: await _file!.readAsBytes());
        PdfTextExtractor extractor = PdfTextExtractor(document);
        extractedText = extractor.extractText();
        document.dispose();
      } else {
        final inputImage = InputImage.fromFilePath(_file!.path);
        final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
        final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
        extractedText = recognizedText.text;
        textRecognizer.close();
      }
      
      setState(() {
        _extractedTextLines = extractedText.split('\n');
        _selectedLines = List.generate(_extractedTextLines.length, (_) => true);
      });
    } catch (e) {
      print('Error extracting text: $e');
      setState(() {
        _extractedTextLines = ['Error extracting text: $e'];
        _selectedLines = [true];
      });
    } finally {
      setState(() {
        _isExtracting = false;
      });
    }
    _navigateToExtractedTextPage();
  }

  void _navigateToExtractedTextPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExtractedTextPage(
          extractedTextLines: _extractedTextLines,
          selectedLines: _selectedLines,
          onSelectionChanged: (index, value) {
            setState(() {
              _selectedLines[index] = value;
            });
          },
          onUpload: _uploadFile,
        ),
      ),
    );
  }

  Future<void> _uploadFile() async {
    if (_file == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String selectedText = _extractedTextLines
          .asMap()
          .entries
          .where((entry) => _selectedLines[entry.key])
          .map((entry) => entry.value)
          .join('\n');

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_file!.path, filename: _file!.path.split('/').last),
        'extractedText': selectedText,
      });

      Response? response = await ApiServices(). requestMultipartApi(
        context: context,
        url: widget.apiUrl,
        formData: formData,
        percent: _uploadProgress,
        authToken: widget.authToken,
      );

      if (response != null && response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully')),
        );
      } else {
        throw Exception('Failed to upload file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
      _uploadProgress.value = 0.0;
    }
  }

  Widget _buildPreview() {
    if (_file == null) {
      return Center(child: Text('No file selected'));
    }

    if (_file!.path.toLowerCase().endsWith('.pdf')) {
      return Container(
        height: 300,
        child: PDFView(
          filePath: _file!.path,
        ),
      );
    } else {
      return Image.file(_file!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker and Text Extractor'),
        actions: [
          IconButton(
            icon: Icon(Icons.text_fields),  // Using a text icon as a representation for ML Kit
            onPressed: _file != null ? _extractText : null,
            tooltip: 'Extract Text with ML Kit',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: Text('Pick Image or PDF'),
                  ),
                  SizedBox(height: 16),
                  Expanded(child: _buildPreview()),
                  SizedBox(height: 16),
                  if (_isExtracting) CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          if (_file != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _uploadFile,
                child: _isUploading ? Text('Uploading...') : Text('Upload File'),
              ),
            ),
          getx.Obx(() => LinearProgressIndicator(
            value: _uploadProgress.value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          )),
        ],
      ),
    );
  }


}

class ExtractedTextPage extends StatelessWidget {
  final List<String> extractedTextLines;
  final List<bool> selectedLines;
  final Function(int, bool) onSelectionChanged;
  final VoidCallback onUpload;

  const ExtractedTextPage({
    Key? key,
    required this.extractedTextLines,
    required this.selectedLines,
    required this.onSelectionChanged,
    required this.onUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extracted Text')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: extractedTextLines.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(extractedTextLines[index]),
                  value: selectedLines[index],
                  onChanged: (bool? value) {
                    if (value != null) {
                      onSelectionChanged(index, value);
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                onUpload();
                Navigator.of(context).pop();
              },
              child: Text('Upload Selected Text'),
            ),
          ),
        ],
      ),
    );
  }
}
