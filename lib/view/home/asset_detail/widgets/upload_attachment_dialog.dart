import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';

Future<void> showUploadAttachmentDialog(
  BuildContext context,
  ClientMgrHomeController controller,
  String recordNo,
) async {
  File? imageFile;

  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.blueShadeGradiant,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );

      if (croppedFile != null) {
        imageFile = File(croppedFile.path);
        await controller.uploadImageApi(imageFile, recordNo, context, true);
      }
    }
  }

  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        width: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Upload Attachment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blueShadeGradiant, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 50,
                    color: AppColors.blueShadeGradiant,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload size maximum 4 MB',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: AppColors.blueShadeGradiant,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await takePicture();
                  },
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: Text(
                    'Camera',
                    style: AppStyles.white_13_600,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: AppColors.blueShadeGradiant,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.pickPdfUnder4MB(context, recordNo);
                  },
                  icon: const Icon(Icons.file_upload, color: Colors.white),
                  label: Text(
                    'Browse',
                    style: AppStyles.white_13_600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}