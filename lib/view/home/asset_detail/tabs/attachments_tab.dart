import 'package:flutter/material.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/model/asset_image_model.dart';
import '../widgets/attachment_list.dart';
import '../widgets/upload_attachment_dialog.dart';

class AttachmentsTab extends StatelessWidget {
  final String recordNo;
  final ClientMgrHomeController controller;

  const AttachmentsTab({
    super.key,
    required this.recordNo,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        // Wrap with Scaffold to properly handle FAB
        backgroundColor: AppColors.absoluteWhite,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<AssetImageModel>(
            future: controller.fetchImage(recordNo: recordNo),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.blueShadeGradiant,
                ));
              }
      
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
      
              if (!snapshot.hasData || snapshot.data!.apiDataArray!.isEmpty) {
                return _buildEmptyState(context);
              }
      
              if (controller.imageList.isEmpty) {
                controller.imageList.value =
                    snapshot.data!.apiDataArray!.toList();
              }
      
              return AttachmentList(controller: controller, recordNo: recordNo);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.blueShadeGradiant,
          onPressed: () =>
              showUploadAttachmentDialog(context, controller, recordNo),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('No attachments available'),
          MaterialButton(
            onPressed: () =>
                showUploadAttachmentDialog(context, controller, recordNo),
            child: const Text("Add Attachments"),
          ),
        ],
      ),
    );
  }
}
