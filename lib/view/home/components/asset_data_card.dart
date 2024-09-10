import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_colors.dart';

class AssetDataCard extends StatefulWidget {
  final String? title;
  final String? data;
  final String? entityName;
  final String? adminBuilding;
  final String? condition;
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

  AssetDataCard({
    Key? key,
    required this.title,
    required this.data,
    required this.entityName,
    required this.adminBuilding,
    required this.condition,
    required this.tag,
    this.wave,
    this.omDepartment,
    this.locationPriority,
    this.complexName,
    this.floorLevel,
    this.floorLevelName,
    this.spaceLocation,
    this.spaceLocationName,
    this.assertDescription,
    this.asserTitle,
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
  State<AssetDataCard> createState() => _AssetDataCardState();
}

class _AssetDataCardState extends State<AssetDataCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.blueShadeGradiant.withOpacity(0.7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.title ?? "",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow("O&M Department", widget.data),
                      _buildInfoRow("Entity Name", widget.entityName),
                      _buildInfoRow(
                          "Functional Classification", widget.adminBuilding),
                      _buildInfoRow("PC Grade", widget.condition),
                      _buildInfoRow("RC O&M Asset Tag#", widget.tag),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Ensures multiline text aligns properly
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.blueShadeGradiant,
          ),
          SizedBox(width: 8),
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.blueShadeGradiant,
            ),
          ),
          Flexible(
            child: Tooltip(
              message: value ?? "",
              child: Text(
                value ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
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
