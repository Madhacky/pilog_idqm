import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import 'package:pilog_idqm/global/widgets/common_shimmer.dart';
import 'package:pilog_idqm/view/home/components/location_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart'; // Ensure you have this import

class AssetDetailsScreen extends StatefulWidget {
  final String? classTerm;
  final String? recordNo;
  final String? shortDescription;
  final String? longDesc;
  final String? status;
  final String? imageName;
  final String? equipmentNo;
  final String? techID;
  final String? lat;
  final String? lng;

  const AssetDetailsScreen(
      {Key? key,
      this.recordNo,
      this.classTerm,
      this.shortDescription,
      this.longDesc,
      this.status,
      this.imageName,
      this.equipmentNo,
      this.techID,
      this.lat,
      this.lng})
      : super(key: key);

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  final home_controller = Get.find<ClientMgrHomeController>();

  late Future getImgFuture =
      controller.DisplayImage(recordNo: widget.recordNo ?? '');
  final List<String> clientQcStatus = [
    "Selected For Random QC",
    "Data Anomalies Identified",
    "Field Inspection In-Progress",
    "Re-Survey Required",
    "Data Approved",
    "Consultant Rejected",
    "Client Rejected",
  ];
  String? selectedClientQcStatus;
  final TextEditingController clientQcCommentsController =
      TextEditingController();
  final ClientMgrHomeController controller =
      Get.find<ClientMgrHomeController>();
  //show image as dummy for test purpose
  File? _image;
  bool isLoading = false;

  Future<void> _takePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      File? croppedImage = await _cropImage(image.path);

      if (croppedImage != null) {
        setState(() {
          _image = croppedImage;
        });
        await home_controller.uploadImageApi(
            _image, widget.recordNo!, context, true);
      }
    }
  }

  Future<File?> _cropImage(String imagePath) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imagePath, uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.deepOrange,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
    ]);

    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }

  String? image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.classTerm ?? "Asset Details",
          style: AppStyles.black_20_600,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 1),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LocationScreen(
                              onLocationSelected:
                                  (double latitude, double longitude) {},
                              assetName: widget.classTerm,
                              equipmentNo: widget.equipmentNo,
                              base64Image: image,
                              lat: widget.lat,
                              long: widget.lng,
                              recordNo: widget.recordNo,
                              status: widget.status,
                            )));
              },
              icon: const Icon(
                Icons.location_on,
                size: 30,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) => CupertinoActionSheet(
                    title: const Text('Select Option'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          _takePicture();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add Image',
                              style: AppStyles.black_15_400,
                            ),
                          ],
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          home_controller.pickPdfUnder4MB(
                              context, widget.recordNo!);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.picture_as_pdf),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add PDF',
                              style: AppStyles.black_15_400,
                            ),
                          ],
                        ),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.attach_file_rounded,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: LoaderOverlay(
        useDefaultLoading: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attachments",
                  style: AppStyles.black_15_600,
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: getImgFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: loadingShimmer());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData ||
                        (snapshot.data as Map)['apiDataArray'].isEmpty) {
                      return const Center(child: Text('No image available'));
                    } else {
                      var imageData = (snapshot.data as Map);
                      image = imageData['apiDataArray'][0]['CONTENT'];
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: imageData['apiDataArray'].length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              // Show Cupertino-style popup on long press
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoPopupSurface(
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                          16), // Increase padding for the popup
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: Get.width,
                                            child: CupertinoButton(
                                              color: CupertinoColors
                                                  .destructiveRed, // Use a red color for delete button
                                              child: Text(
                                                'Delete',
                                                style: AppStyles
                                                    .white_18_400, // Increase font size
                                              ),
                                              onPressed: () async {
                                                await controller.imageDeleteApi(
                                                    imageData['apiDataArray']
                                                        [index]['AUDIT_ID'],
                                                    widget.recordNo!,
                                                    context);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  8), // Add spacing between buttons
                                          CupertinoButton(
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize:
                                                      18), // Increase font size
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the popup
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            onTap: () {
                              home_controller.isImageOrPdf(
                                      imageData['apiDataArray'][index]
                                          ['CONTENT'])
                                  ? home_controller.showImages(
                                      context,
                                      imageData['apiDataArray'][index]
                                          ['CONTENT'],
                                      imageData['apiDataArray'][index]
                                              ['FILE_NAME'] ??
                                          'No name',
                                    )
                                  : home_controller.showPDF(
                                      context,
                                      imageData['apiDataArray'][index]
                                          ['CONTENT'],
                                      imageData['apiDataArray'][index]
                                              ['FILE_NAME'] ??
                                          'No name',
                                    );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.ashGrey),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: home_controller.isImageOrPdf(
                                        imageData['apiDataArray'][index]
                                            ['CONTENT'])
                                    ? Image.memory(
                                        base64Decode(imageData['apiDataArray']
                                            [index]['CONTENT']),
                                        fit: BoxFit.fill,
                                        height: 30,
                                        width: 30,
                                      )
                                    : Image.asset(
                                        "assets/images/pdf_image.png",
                                        fit: BoxFit.fill,
                                        height: 30,
                                        width: 30,
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                _buildDetailField("Class Term", widget.classTerm),
                _buildDetailField("Record No", widget.recordNo),
                _buildDetailField("Equipment No", widget.equipmentNo),
                _buildDetailField("Tech ID", widget.techID),
                _buildDetailField("Short Description", widget.shortDescription),
                _buildDetailField("Long Description", widget.longDesc),
                _buildDetailField("Status", widget.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                style: AppStyles.black_15_600,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            enabled: false,
            initialValue: value ?? '',
            style: const TextStyle(color: Colors.black87),
            maxLines: null, // This allows the text field to grow as needed
            minLines: 1, // The minimum number of lines to display
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: clientQcCommentsController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2, // Show 2 shimmer items during loading
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ashGrey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                color: Colors.grey, // Placeholder color
                height: 50,
                width: 50,
              ),
            ),
          ),
        );
      },
    );
  }
}
