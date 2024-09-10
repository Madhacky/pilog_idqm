import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/global/widgets/common_shimmer.dart';


class AssetDetailsScreen extends StatefulWidget {
  final String? entityName;
  final String? tag;
  final String? wave;
  final String? omDepartment;
  final String? locationPriority;
  final String? complexName;
  final String? floorLevel;
  final String? floorLevelName;
  final String? spaceLocation;
  final String? spaceLocationName;
  final String? assertDescription;
  final String? asserTitle;
  final String? pgGrade;
  final String? pgGradeName;
  final String? fieldComments;
  final String? recordNo;
  final String? astOrgId;
  final String? orgName;
  final String? regionId;
  final String? regionName;
  final String? cityId;
  final String? cityName;
  final String? areaId;
  final String? areaName;
  final String? districtId;
  final String? districtName;
  final String? sectionId;
  final String? sectionName;
  final String? gisLocator;
  final String? gisLinkId;
  final String? geoLocation;
  final String? geoMapLink;
  final String? existTagNumber;
  final String? manufacture;
  final String? model;
  final String? pinNumber;
  final String? manufactureYear;
  final String? drawingNumber;
  final String? drawingName;
  final String? drawingRev;
  final String? drawingType;
  final String? surveyedBy;
  final String? surveyedDate;
  final String? internalQcBy;
  final String? internalQcDate;
  final String? clientQcBy;
  final String? clientQcDate;
  final String? clientQcStatus;
  final String? clientQcCommets;
  final String? submissionTo;
  final String? submissionDATE;
  final String? uniClassCode;
  final String? uniClassTitle;
  final String? functionalClassification;
  final String? uniEnCode;
  final String? uniEnTitle;
  final String? uniClassSlCode;
  final String? uniClassSlTitle;
  final String? assetVariantDescription;
  final String? asBuiltRef;
  final String? assetQty;

  const AssetDetailsScreen({
    Key? key,
    this.entityName,
    this.tag,
    this.wave,
    this.omDepartment,
    this.locationPriority,
    this.complexName,
    this.floorLevel,
    this.floorLevelName,
    this.spaceLocation,
    this.spaceLocationName,
    this.asserTitle,
    this.assertDescription,
    this.pgGrade,
    this.pgGradeName,
    this.fieldComments,
    this.recordNo,
    this.astOrgId,
    this.orgName,
    this.regionId,
    this.regionName,
    this.cityId,
    this.cityName,
    this.areaId,
    this.areaName,
    this.districtId,
    this.districtName,
    this.sectionId,
    this.sectionName,
    this.gisLocator,
    this.gisLinkId,
    this.geoLocation,
    this.geoMapLink,
    this.existTagNumber,
    this.asBuiltRef,
    this.assetQty,
    this.uniEnCode,
    this.uniEnTitle,
    this.uniClassSlCode,
    this.uniClassSlTitle,
    this.assetVariantDescription,
    this.clientQcBy,
    this.clientQcDate,
    this.clientQcStatus,
    this.clientQcCommets,
    this.drawingName,
    this.drawingNumber,
    this.drawingRev,
    this.drawingType,
    this.functionalClassification,
    this.internalQcBy,
    this.internalQcDate,
    this.manufacture,
    this.manufactureYear,
    this.model,
    this.pinNumber,
    this.submissionDATE,
    this.submissionTo,
    this.surveyedBy,
    this.surveyedDate,
    this.uniClassCode,
    this.uniClassTitle,
  }) : super(key: key);

  @override
  State<AssetDetailsScreen> createState() => _AssetDetailsScreenState();
}

class _AssetDetailsScreenState extends State<AssetDetailsScreen> {
  late Future getImgFuture= controller.DisplayImage(recordNo: widget.recordNo ?? '');
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
//  File? _image;
//   bool isLoading = false;

//   Future<void> _takePicture() async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);

//     if (image != null) {
//       File? croppedImage = await _cropImage(image.path);

//       if (croppedImage != null) {
//         setState(() {
//           _image = croppedImage;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Image uploaded successfully')),
//         );
//       }
//     }
//   }

//   Future<File?> _cropImage(String imagePath) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: imagePath,
    
//       uiSettings:[ AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         toolbarColor: Colors.deepOrange,
//         toolbarWidgetColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false,
//       ),
//       ]
//     );

//     if (croppedFile != null) {
//       return File(croppedFile.path);
//     }
//     return null;
//   }

//  void _showSelectedImage() async {
//   if (_image != null) {
//     setState(() {
//       isLoading = true;
//     });

//     await Future.delayed(Duration(seconds: 2)); // Simulate a loading delay

//     setState(() {
//       isLoading = false;
//     });

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true, // Allows the bottom sheet to expand to full screen
//       backgroundColor: Colors.transparent, // Make background transparent for better UI
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.95, // Set height as 75% of the screen
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                   const  Text(
//                       'Selected Image',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: PhotoView(
//                     imageProvider: FileImage(_image!),
//                     backgroundDecoration: BoxDecoration(
//                       color: Colors.white,
//                     ),
//                     minScale: PhotoViewComputedScale.contained * 0.8,
//                     maxScale: PhotoViewComputedScale.covered * 2,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('No image selected')),
//     );
//   }
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assertDescription ?? "Asset Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          //  Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: IconButton(
          //     onPressed: _showSelectedImage,
          //     icon: Icon(
          //       Icons.image,
          //       size: 30,
          //     ),
          //   ),
          // ),
          
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),
          //   child: IconButton(
          //     onPressed: _takePicture,
          //     icon: Icon(
          //       Icons.add_a_photo_outlined,
          //       size: 30,
          //     ),
          //   ),
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailField("Wave", widget.wave),
              _buildDetailField("Department", widget.omDepartment),
              _buildDetailField("Entity Name", widget.entityName),
              _buildDetailField("Location Priority", widget.locationPriority),
              _buildDetailField("Complex Name", widget.complexName),
              _buildDetailField("Tag", widget.tag),
              _buildDetailField("Floor Level", widget.floorLevel),
              _buildDetailField("Floor Level Name", widget.floorLevelName),
              _buildDetailField("Space Location", widget.spaceLocation),
              _buildDetailField(
                  "Space Location Name", widget.spaceLocationName),
              _buildDetailField("Asset Title", widget.asserTitle),
              _buildDetailField("Asset Description", widget.assertDescription),
              _buildDetailField("PG Grade", widget.pgGrade),
              _buildDetailField("PG Grade Name", widget.pgGradeName),
              _buildDetailField("Field Comments", widget.fieldComments),
              _buildDetailField("Record Number", widget.recordNo),
              _buildDropdownField(context, "Client QC Status"),
              _buildTextField("Client QC Comments"),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String recordNo = widget.recordNo ?? '';
                    String masterColumn14 = selectedClientQcStatus ?? '';
                    String masterColumn13 = clientQcCommentsController.text;

                    await controller.updateClientMgrQcRecord(
                      recordNo: recordNo,
                      masterColumn14: masterColumn14,
                      masterColumn13: masterColumn13,
                    );
                  },
                  child: const Text('UPDATE'),
                ),
              ),
              const SizedBox(height: 20),
            const  Text("Attachments",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
             const SizedBox(height: 10,),
              FutureBuilder(
                future:getImgFuture,
                   
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: loadingShimmer());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      (snapshot.data as Map)['apiDataArray'].isEmpty) {
                    return Center(child: Text('No image available'));
                  } else {
                    var imageData = (snapshot.data as Map);
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: imageData['apiDataArray'].length,
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return Image.memory(
                          base64Decode(
                            imageData['apiDataArray'][index]['CONTENT'],
                          ),
                          fit: BoxFit.fill,
                          height: 50,
                          width: 50,
                        );
                      },
                    );
                  }
                },
              ),
              _buildExpansionTile("GIS", [
                _buildGrid([
                  _buildGridTile("Org ID", widget.astOrgId ?? "N/A"),
                  _buildGridTile("Org Name", widget.orgName ?? "N/A"),
                  _buildGridTile("Region ID", widget.regionId ?? "N/A"),
                  _buildGridTile("Region Name", widget.regionName ?? "N/A"),
                  _buildGridTile("City ID", widget.cityId ?? "N/A"),
                  _buildGridTile("City Name", widget.cityName ?? "N/A"),
                  _buildGridTile("Area ID", widget.areaId ?? "N/A"),
                  _buildGridTile("Area Name", widget.areaName ?? "N/A"),
                  _buildGridTile(
                      "District/Industry ID", widget.districtId ?? "N/A"),
                  _buildGridTile(
                      "District/Industry Name", widget.districtName ?? "N/A"),
                  _buildGridTile("Sec ID", widget.sectionId ?? "N/A"),
                  _buildGridTile("Sec Name", widget.sectionName ?? "N/A"),
                  _buildGridTile("GIS Locator", widget.gisLocator ?? "N/A"),
                  _buildGridTile("GIS Link ID", widget.gisLinkId ?? "N/A"),
                  _buildGridTile("Geographical Location (X,Y)",
                      widget.geoLocation ?? "N/A"),
                  _buildGridTile(
                      "Google Maps Link", widget.geoMapLink ?? "N/A"),
                ]),
              ]),
              _buildExpansionTile("Tag Info & Name Plate", [
                _buildGrid([
                  _buildGridTile("Existing Tag Number", widget.existTagNumber ?? "N/A"),
                  _buildGridTile("RC O&M Asset Tag Number", "N/A"), // Add relevant field if available
                  _buildGridTile("Manufacturer", widget.manufacture ?? "N/A"),
                  _buildGridTile("Model", widget.model ?? "N/A"),
                  _buildGridTile("Serial/PIN/VIN/Chassis Number", widget.pinNumber ?? "N/A"),
                  _buildGridTile("Manufacturing Year", widget.manufactureYear ?? "N/A"),
                ]),
              ]),
              _buildExpansionTile("Document", [
                _buildGrid([
                  _buildGridTile("Drawing Name", widget.drawingName ?? "N/A"),
                  _buildGridTile("Drawing Type", widget.drawingType ?? "N/A"),
                  _buildGridTile("Drawing Number", widget.drawingNumber ?? "N/A"),
                  _buildGridTile("Drawing Revision", widget.drawingRev ?? "N/A"),
                  _buildGridTile("As Built Reference", widget.asBuiltRef ?? "N/A"),
                  _buildGridTile("Asset Quantity", widget.assetQty ?? "N/A"),
                ]),
              ]),
              _buildExpansionTile("QA/QC", [
                _buildGrid([
                  _buildGridTile("Surveyed By", widget.surveyedBy ?? "N/A"),
                  _buildGridTile("Surveyed Date", widget.surveyedDate ?? "N/A"),
                  _buildGridTile("Internal QC By", widget.internalQcBy ?? "N/A"),
                  _buildGridTile("Internal QC Date", widget.internalQcDate ?? "N/A"),
                  _buildGridTile("Client QC By", widget.clientQcBy ?? "N/A"),
                  _buildGridTile("Client QC Date", widget.clientQcDate ?? "N/A"),
                  _buildGridTile("Client QC Status", widget.clientQcStatus ?? "N/A"),
                  _buildGridTile("Client QC Comments", widget.clientQcCommets ?? "N/A"),
                  _buildGridTile("Submission To", widget.submissionTo ?? "N/A"),
                  _buildGridTile("Submission Date", widget.submissionDATE ?? "N/A"),
                ]),
              ]),
              _buildExpansionTile("Uni Class", [
                _buildGrid([
                  _buildGridTile("Uni Class Code", widget.uniClassCode ?? "N/A"),
                  _buildGridTile("Uni Class Title", widget.uniClassTitle ?? "N/A"),
                  _buildGridTile("Functional Classification", widget.functionalClassification ?? "N/A"),
                  _buildGridTile("Uni Class SL Code", widget.uniClassSlCode ?? "N/A"),
                  _buildGridTile("Uni Class SL Title", widget.uniClassSlTitle ?? "N/A"),
                  _buildGridTile("Uni EN Code", widget.uniEnCode ?? "N/A"),
                  _buildGridTile("Uni EN Title", widget.uniEnTitle ?? "N/A"),
                ]),
              ]),
              _buildExpansionTile("Variant Information", [
                _buildGrid([
                  _buildGridTile("Asset Variant Description", widget.assetVariantDescription ?? "N/A"),
                ]),
              ]),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildDetailField(String label, String? value) {
    return Column(

      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4,),
              child: Text(label),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
             enabled: false,
             initialValue: value ?? '',  
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextField(
            controller: clientQcCommentsController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text('Select $label'),
              items: clientQcStatus
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              value: selectedClientQcStatus,
              onChanged: (value) {
                setState(() {
                  selectedClientQcStatus = value as String;
                });
              },
            
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 2,
        child: ExpansionTile(
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 3,
      crossAxisSpacing: 3,
      childAspectRatio: 1.1,
      padding: const EdgeInsets.all(8.0),
      children: children,
    );
  }

  Widget _buildGridTile(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }
Widget loadingShimmer() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  height: 170,
                  width: 160,
                  child: const CommonShimmer()),
                      SizedBox(
                  height: 170,
                  width: 160,
                  child: const CommonShimmer()),
            ],
          ),
         
        ],
      ),
    );
  }

}
