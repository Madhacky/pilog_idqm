import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/model/asset_image_model.dart';

class AttachmentList extends StatelessWidget {
  final ClientMgrHomeController controller;
  final String recordNo;

  const AttachmentList({
    super.key,
    required this.controller,
    required this.recordNo,
  });

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Attachment'),
          content: const Text('Are you sure you want to delete this attachment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final item = controller.imageList[index];
                await controller.imageDeleteApi(
                  item.aUDITID!,
                  recordNo,
                  context,
                  index,
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 5),
        shrinkWrap: true,
        itemCount: controller.imageList.length,
        itemBuilder: (context, index) {
          final item = controller.imageList[index];
          return ListTile(
            onLongPress: () => _showDeleteConfirmation(context, index),
            onTap: () {
              if (controller.isImageOrPdf(item.cONTENT!)) {
                controller.showImages(
                  context,
                  item.cONTENT!,
                  item.fILENAME ?? 'No name',
                );
              } else {
                controller.showPDF(
                  context,
                  item.cONTENT!,
                  item.fILENAME ?? 'No name',
                );
              }
            },
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            leading: _buildAttachmentIcon(item),
            title: Text(
              "File Name: ${item.fILENAME}",
              style: AppStyles.black_14_400,
            ),
            subtitle: Text(
              "Create Date: ${item.cREATEDATE.toString()}",
              style: AppStyles.black_12_400,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttachmentIcon(ApiDataArray  item) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: controller.isImageOrPdf(item.cONTENT!)
          ? Image.memory(
              base64Decode(item.cONTENT!),
              fit: BoxFit.fill,
            )
          : Image.asset(
              "assets/images/pdf_image.png",
              fit: BoxFit.fill,
            ),
    );
  }
}