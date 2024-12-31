import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfController extends GetxController {
  String? _pdfText;
  String? _summary;
  bool _isLoading = false;
  File? _selectedFile;

  String? get pdfText => _pdfText;
  String? get summary => _summary;
  bool get isLoading => _isLoading;
  File? get selectedFile => _selectedFile;

  Future<void> pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        _selectedFile = File(result.files.single.path!);
        await extractText();
        update();
      }
    } catch (e) {
      debugPrint('Error picking PDF: $e');
    }
  }

  Future<void> extractText() async {                                                          
    if (_selectedFile == null) return;

    try {
      _isLoading = true;
      update();

      final PdfDocument document = PdfDocument(inputBytes: await _selectedFile!.readAsBytes());
      PdfTextExtractor extractor = PdfTextExtractor(document);
      _pdfText = extractor.extractText();
      document.dispose();

      await generateSummary();
    } catch (e) {
      debugPrint('Error extracting text: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }

  Future<void> generateSummary() async {
    if (_pdfText == null) return;

    try {
      _isLoading = true;
      update();

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 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', // Replace with your API key
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that generates concise summaries.'
            },
            {
              'role': 'user',
              'content': 'Please provide a concise summary of the following text: $_pdfText'
            }
          ],
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _summary = data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to generate summary');
      }
    } catch (e) {
      debugPrint('Error generating summary: $e');
    } finally {
      _isLoading = false;
      update();
    }
  }
}