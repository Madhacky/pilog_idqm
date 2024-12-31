import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/pdf_extractor_controller.dart';
import '../widgets/summary_card.dart';

class PdfSummaryScreen extends StatelessWidget {
  const PdfSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Summary'),
        centerTitle: true,
      ),
      body: GetBuilder<PdfController>(
        init: PdfController(), // Initialize the controller
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: controller.isLoading ? null : controller.pickPDF,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload PDF'),
                ),
                const SizedBox(height: 20),
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (controller.selectedFile != null) ...[
                  Text(
                    'Selected File: ${controller.selectedFile!.path.split('/').last}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (controller.summary != null)
                    SummaryCard(summary: controller.summary!),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
