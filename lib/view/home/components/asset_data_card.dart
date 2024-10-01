import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pilog_idqm/view/home/components/assest_details_screen.dart';

class AssetDataCard extends StatefulWidget {
  final String? classTerm;
  final String? recordNo;
  final String? shortDescription;
  final String? longDesc;
  final String? status;
  final String? imageName;

  // final String? registerColumn8;
  // final String? registerColumn5;
  // final String? abbreviation;
  // final String? clientNumber;
  // final String? equipmentCategory;
  // final String? unspscCode;
  // final String? buCustCol26;
  // final String? startupDate;
  // final String? createdOn;
  // final String? domain;
  // final String? erpsfd;
  // final String? descriptionOfTechObj;
  // final String? originalShort;
  // final String? typeOfTechObj;
  // final String? constructionYear;
  // final String? plant;
  // final String? auditId;
  // final String? manufacturer;
  // final String? manufacturerModel;
  // final String? equipCatForProduction;
  // final String? vendorNumber;
  // final String? floc;
  // final String? recordNo;
  // final String? objectNumber;
  // final String? orgnId;
  // final String? materialNumber;

  AssetDataCard(
      {Key? key,
      this.recordNo,
      this.classTerm,
      this.shortDescription,
      this.longDesc,
      this.status, this.imageName

      // this.registerColumn8,
      // this.registerColumn5,
      // this.abbreviation,
      // this.clientNumber,
      // this.equipmentCategory,
      // this.unspscCode,
      // this.buCustCol26,
      // this.startupDate,
      // this.createdOn,
      // this.domain,
      // this.erpsfd,
      // this.descriptionOfTechObj,
      // this.originalShort,
      // this.typeOfTechObj,
      // this.constructionYear,
      // this.plant,
      // this.auditId,
      // this.manufacturer,
      // this.manufacturerModel,
      // this.equipCatForProduction,
      // this.vendorNumber,
      // this.floc,
      // this.recordNo,
      // this.objectNumber,
      // this.orgnId,
      // this.materialNumber,
      })
      : super(key: key);

  @override
  State<AssetDataCard> createState() => _AssetDataCardState();
}

class _AssetDataCardState extends State<AssetDataCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute<bool>(
              builder: (_) => AssetDetailsScreen(
                    classTerm: widget.classTerm,
                    longDesc: widget.longDesc,
                    recordNo: widget.recordNo,
                    shortDescription: widget.shortDescription,
                    status: widget.status,imageName: widget.imageName,
                  ))),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
           //   color: Color(0xff7165E3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with gradient background and title
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff7165E3), Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.classTerm ?? "",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffe8e7f4),
                        ),
                      ),
                    ),
                  ),
                  // Content with information rows
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("RECORD NO", widget.recordNo),
                        SizedBox(height: 5),
                        _buildInfoRow("STATUS", widget.status),
                        //  SizedBox(height: 5),
                        // _buildInfoRow("CLASS_TERM	", widget.classTerm),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            //  color: Color(0xffe8e7f4),
            ),
          ),
          Flexible(
            child: Tooltip(
              message: value ?? "",
              child: Text(
                value ?? "",
                style: TextStyle(
                  fontSize: 16,
                //  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
