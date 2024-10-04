import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:pilog_idqm/view/parametric%20search/paramertic_search_result.dart';

class ParametricSearchController extends GetxController {
  static late String host_url;

  @override
  void onInit() {
    super.onInit();
    host_url = dotenv.get("HOST_URL");
    getMdrmNumber("RECORD_NO", mdrmNumbers, isMdrmNumbersLoaded);
    getMdrmNumber(
        "BU_DH_CUST_COL53", equipmentNumbers, isequipmentNumbersLoaded);
    getMdrmNumber("REGISTER_COLUMN6", techIds, istechIdsLoaded);
    getMdrmNumber("FLOC", flocs, isflocsLoaded);
  }

  // Dummy data for dropdown fields
  RxList<String> mdrmNumbers = RxList();
  RxList<String> equipmentNumbers = RxList();
  RxList<String> techIds = RxList();
  RxList<String> flocs = RxList();

  // Operators including the new ones
  final List<String> operators = [
    '',
    '=',
    'LIKE',
    'IN',
    'NOT IN',
    'IS',
    'IS NOT',
    'NOT LIKE',
  ];

  // Selected values
  var selectedMdrmOperator = ''.obs;
  var selectedEquipmentOperator = ''.obs;
  var selectedTechIDOperator = ''.obs;
  var selectedFLOCOperator = ''.obs;

  var selectedMdrmValue = ''.obs;
  var selectedEquipmentValue = ''.obs;
  var selectedTechIDValue = ''.obs;
  var selectedFLOCValue = ''.obs;

  // Text controllers for manual input
  var mdrmTextController = TextEditingController();
  var equipmentTextController = TextEditingController();
  var techIDTextController = TextEditingController();
  var flocTextController = TextEditingController();

  RxBool isMdrmNumbersLoaded =
      false.obs; // Used to determine if items are loaded
  RxBool isequipmentNumbersLoaded = false.obs;
  RxBool istechIdsLoaded = false.obs;
  RxBool isflocsLoaded = false.obs;

  // Search function
  void performSearch(BuildContext context) {
    sQLQuery = '';
    Navigator.push(
        context,
        CupertinoPageRoute<bool>(
            builder: (_) => const ParametricSearchResultScreen()));

    //   generateSQLQuery();
  }

//get dropdown value for mrdm number
  Future<List<String>> getMdrmNumber(
      String columnName, RxList<String> items, RxBool isItemLoaded) async {
    try {
      final response = await ApiServices().requestPostForApi(
        url: "${host_url}getApiRequestResultsData",
        dictParameter: {
          "apiReqId": "7B105EDE59C442D585198D501FED3B51",
          "apiReqCols": "'' AS EMPTY_COL ,$columnName",
          "apiReqWhereClause": "",
          "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
          "apiReqUserId": "KT_VBR_MGR",
          "apiRetType": "JSON"
        },
        authToken: false,
      );

      log("status ${response?.statusCode}");
      if (response?.statusCode == 200) {
        var result = jsonDecode(response!.data.toString());
        for (var object in result!['apiDataArray']) {
          items.add(object[columnName]);
        }
        log("adataaaaaa ${items.length}");
        isItemLoaded.value = true;
        update();
        return items;
      } else {
        return Future.error('Error: ${response?.statusCode}');
      }
    } catch (e) {
      log("error $e");
      return Future.error(e.toString());
    }
  }

  //generate SQL Query
  List<String> whereConditions = [];
  String? finalQuery;
  String whereClause = "1";
  int offset = 0;
  int rows = 10;
  String generateSQLQuery() {
    finalQuery = "";
    whereConditions.clear();
    whereClause = '1';
    if ({mdrmTextController.text} != null && {mdrmTextController.text} != "") {
      if (!(selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "")) {
        whereConditions.add(
            "  UPPER(RECORD_NO)  LIKE  UPPER( '%${mdrmTextController.text}%')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "LIKE") {
        whereConditions.add(
            "  UPPER(RECORD_NO) $selectedMdrmOperator.value  UPPER( '%${mdrmTextController.text}%')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "NOT LIKE") {
        whereConditions.add(
            "  UPPER(RECORD_NO) $selectedMdrmOperator.value  UPPER( '%${mdrmTextController.text}%')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "=") {
        whereConditions.add(
            "  UPPER(RECORD_NO) $selectedMdrmOperator.value  UPPER( '${mdrmTextController.text}')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "Beginning With") {
        whereConditions.add(
            "  UPPER(RECORD_NO) LIKE  UPPER( '${mdrmTextController.text}%')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "Ending With") {
        whereConditions.add(
            "  UPPER(RECORD_NO) LIKE  UPPER( '%${mdrmTextController.text}')");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "IS") {
        whereConditions.add("  UPPER(RECORD_NO) IS NULL");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(RECORD_NO) IS NOT NULL");
      } else if (selectedMdrmOperator.value != null &&
          selectedMdrmOperator.value != "" &&
          selectedMdrmOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(RECORD_NO) IS NOT NULL");
      } else {
        whereConditions.add(
            "  UPPER(RECORD_NO) $selectedMdrmOperator.value  UPPER( '${mdrmTextController.text}')");
      }
    }
    if ({equipmentTextController.text} != null &&
        {equipmentTextController.text} != "") {
      if (!(selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "")) {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53)  LIKE  UPPER( '%${equipmentTextController.text}%')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "LIKE") {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) $selectedEquipmentOperator.value  UPPER( '%${equipmentTextController.text}%')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "NOT LIKE") {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) $selectedEquipmentOperator.value  UPPER( '%${equipmentTextController.text}%')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "=") {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) $selectedEquipmentOperator.value  UPPER( '${equipmentTextController.text}')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "Beginning With") {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) LIKE  UPPER( '${equipmentTextController.text}%')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "Ending With") {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) LIKE  UPPER( '%${equipmentTextController.text}')");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "IS") {
        whereConditions.add("  UPPER(BU_DH_CUST_COL53) IS NULL");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(BU_DH_CUST_COL53) IS NOT NULL");
      } else if (selectedEquipmentOperator.value != null &&
          selectedEquipmentOperator.value != "" &&
          selectedEquipmentOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(BU_DH_CUST_COL53) IS NOT NULL");
      } else {
        whereConditions.add(
            "  UPPER(BU_DH_CUST_COL53) $selectedEquipmentOperator.value  UPPER( '${equipmentTextController.text}')");
      }
    }
    if ({techIDTextController.text} != null &&
        {techIDTextController.text} != "") {
      if (!(selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "")) {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6)  LIKE  UPPER( '%${techIDTextController.text}%')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "LIKE") {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) $selectedTechIDOperator.value  UPPER( '%${techIDTextController.text}%')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "NOT LIKE") {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) $selectedTechIDOperator.value  UPPER( '%${techIDTextController.text}%')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "=") {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) $selectedTechIDOperator.value  UPPER( '${techIDTextController.text}')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "Beginning With") {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) LIKE  UPPER( '${techIDTextController.text}%')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "Ending With") {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) LIKE  UPPER( '%${techIDTextController.text}')");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "IS") {
        whereConditions.add("  UPPER(REGISTER_COLUMN6) IS NULL");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(REGISTER_COLUMN6) IS NOT NULL");
      } else if (selectedTechIDOperator.value != null &&
          selectedTechIDOperator.value != "" &&
          selectedTechIDOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(REGISTER_COLUMN6) IS NOT NULL");
      } else {
        whereConditions.add(
            "  UPPER(REGISTER_COLUMN6) $selectedTechIDOperator.value  UPPER( '${techIDTextController.text}')");
      }
    }
    if ({flocTextController.text} != null && {flocTextController.text} != "") {
      if (!(selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "")) {
        whereConditions
            .add("  UPPER(FLOC)  LIKE  UPPER( '%${flocTextController.text}%')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "LIKE") {
        whereConditions.add(
            "  UPPER(FLOC) $selectedFLOCOperator.value  UPPER( '%${flocTextController.text}%')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "NOT LIKE") {
        whereConditions.add(
            "  UPPER(FLOC) $selectedFLOCOperator.value  UPPER( '%${flocTextController.text}%')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "=") {
        whereConditions.add(
            "  UPPER(FLOC) $selectedFLOCOperator.value  UPPER( '${flocTextController.text}')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "Beginning With") {
        whereConditions
            .add("  UPPER(FLOC) LIKE  UPPER( '${flocTextController.text}%')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "Ending With") {
        whereConditions
            .add("  UPPER(FLOC) LIKE  UPPER( '%${flocTextController.text}')");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "IS") {
        whereConditions.add("  UPPER(FLOC) IS NULL");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(FLOC) IS NOT NULL");
      } else if (selectedFLOCOperator.value != null &&
          selectedFLOCOperator.value != "" &&
          selectedFLOCOperator.value == "IS NOT") {
        whereConditions.add("  UPPER(FLOC) IS NOT NULL");
      } else {
        whereConditions.add(
            "  UPPER(FLOC) $selectedFLOCOperator.value  UPPER( '${flocTextController.text}')");
      }
    }
    if (whereConditions.isNotEmpty) {
      whereClause = whereConditions.join(" AND ").toUpperCase();
    }

    finalQuery =
        "${whereClause}AND RECORD_NO IS NOT NULL OFFSET ${offset.toString()} ROWS FETCH NEXT ${rows.toString()} ROWS ONLY";

    return finalQuery ?? "";
  }

  //parametric search api
  late Future<List<AssetDataCard>> getParametricSearchResultFuture;
  final List<AssetDataCard> assetCardList = [];
  String sQLQuery = '';
  Future<List<AssetDataCard>> parametricSearch() async {
    sQLQuery = generateSQLQuery();
    assetCardList.clear();
    try {
      final response = await ApiServices().requestPostForApi(
        url: "${host_url}getApiRequestResultsData",
        dictParameter: {
          "apiReqId": "7B105EDE59C442D585198D501FED3B51",
          "apiReqCols": "",
          "apiReqWhereClause": sQLQuery,
          "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
          "apiReqUserId": "KT_VBR_MGR",
          "apiRetType": "JSON"
        },
        authToken: false,
      );

      log("status ${response?.statusCode}");
      if (response?.statusCode == 200) {
        var result = jsonDecode(response!.data.toString());
        for (var object in result!['apiDataArray']) {
          assetCardList.add(AssetDataCard(
            classTerm: object["CLASS_TERM"],
            longDesc: object["MASTER_COLUMN6"],
            recordNo: object["RECORD_NO"],
            status: object["STATUS"],
            shortDescription: object["MASTER_COLUMN5"],
            equipmentNumber: object["BU_DH_CUST_COL53"],
            techId: object["REGISTER_COLUMN6"],
          ));
        }
        log("adataaaaaa ${result!['apiDataArray'][0]["RECORD_NO"]}");
        return assetCardList;
      } else {
        return Future.error('Error: ${response?.statusCode}');
      }
    } catch (e) {
      log("error $e");
      return Future.error(e.toString());
    }
  }

}
