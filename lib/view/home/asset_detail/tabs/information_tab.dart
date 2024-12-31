import 'package:flutter/material.dart';
import 'package:pilog_idqm/global/app_colors.dart';
import 'package:pilog_idqm/global/app_styles.dart';
import '../widgets/detail_field.dart';

class InformationTab extends StatelessWidget {
  final String? classTerm;
  final String? recordNo;
  final String? shortDescription;
  final String? longDesc;
  final String? status;
  final String? equipmentNo;
  final String? techID;

  const InformationTab({
    super.key,
    this.classTerm,
    this.recordNo,
    this.shortDescription,
    this.longDesc,
    this.status,
    this.equipmentNo,
    this.techID,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildWhiteInfoCard(cardHeadTitle: "General Information", children: [
            DetailField(label: "Class Term", value: classTerm),
            DetailField(label: "Record No", value: recordNo),
            DetailField(label: "Equipment No", value: equipmentNo),
            DetailField(label: "Tech ID", value: techID),
          ]),
          buildWhiteInfoCard(children: [
            DetailField(label: "Short Description", value: shortDescription),
            DetailField(label: "Long Description", value: longDesc),
          ], cardHeadTitle: 'Description'),
          buildWhiteInfoCard(children: [
            DetailField(label: "Status", value: status),
          ], cardHeadTitle: "Status")
        ],
      ),
    );
  }

  Widget buildWhiteInfoCard(
      {required List<Widget> children, required String cardHeadTitle}) {
    return Card(elevation: 0,
    color: AppColors.absoluteWhite,
      shape: const RoundedRectangleBorder(side: BorderSide(color: AppColors.blueShadeGradiant,),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  cardHeadTitle,
                  style: AppStyles.black_16_600,
                ),
                 const SizedBox(
                  width: 10,
                ),
                const Flexible(child: Divider(thickness: 1,)),
              
              ],
            ),
              const SizedBox(
                  height: 10,
                ),
            ...children
          ],
        ),
      ),
    );
  }
}
