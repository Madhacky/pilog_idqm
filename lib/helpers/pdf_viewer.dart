import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'dart:io';

class PDFScreen extends StatelessWidget {
  final String pdfPath;

  const PDFScreen({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: SfPdfViewer.file(File(pdfPath)),
    );
  }
}
