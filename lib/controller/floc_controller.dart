import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';

class FlocController extends GetxController {
  static late String host_url;

  @override
  void onInit() {
    super.onInit();
    host_url = dotenv.get("HOST_URL");
  }

  //floc api
  static final List<String> _flocIds = [];
  List<String> get flocIds => _flocIds;
  late Future<List<String>> getFlocIdsFuture;
  Future<List<String>> getFlocInfoApi() async {
    _flocIds.clear();
    try {
      final response = await ApiServices().requestPostForApi(
        url: "${host_url}getApiRequestResultsData",
        dictParameter: {
          "apiReqId": "7B105EDE59C442D585198D501FED3B51",
          "apiReqCols": "'' AS EMPTY_COL, RECORD_NO,FLOC",
          "apiReqWhereClause": "",
          "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
          "apiReqUserId": "",
          "apiRetType": "JSON"
        },
        authToken: false,
      );

      log("status ${response?.statusCode}");
      if (response?.statusCode == 200) {
        var result = jsonDecode(response!.data.toString());
        for (var object in result!['apiDataArray']) {
          _flocIds.add(object["FLOC"]);
        }
        return flocIds;
      } else {
        return Future.error('Error: ${response?.statusCode}');
      }
    } catch (e) {
      log("error $e");
      return Future.error(e.toString());
    }
  }

  //FLOC OPERATIONS
  // Method to filter the list based on the search query
  // To store the filtered list based on the search query
  RxList<MapEntry<String, int>> filteredFLOCEntries = RxList();
  // To keep track of the search query
  String searchQuery = '';
  void filterFLOC(String query) {
    // Create a map that stores the count of each FLOC element, normalizing the strings
    final Map<String, int> flocCount = {};

    // Count the occurrences of each FLOC item from the controller
    for (var item in flocIds) {
      if (item != null && item.isNotEmpty) {
        // Normalize FLOC item by trimming and converting to lowercase
        String normalizedItem = item.trim().toLowerCase();
        flocCount[normalizedItem] = (flocCount[normalizedItem] ?? 0) + 1;
      }
    }

    // Filter the map based on the normalized search query
    final filteredMap = flocCount.entries
        .where((entry) => entry.key.contains(query.trim().toLowerCase()))
        .toList();

    filteredFLOCEntries.value = filteredMap;
    update();
  }

  //search record based on floc id
  late Future<List<AssetDataCard>> getFlocSearchResultFuture;
  List<AssetDataCard> assetCardList = [];

  Future<List<AssetDataCard>> getFlocData(String value) async {
    assetCardList.clear();
    String finalquery =
        "UPPER (FLOC) LIKE UPPER ('$value') AND RECORD_NO IS NOT NULL";
    try {
      final response = await ApiServices().requestPostForApi(
        url: "${host_url}getApiRequestResultsData",
        dictParameter: {
          "apiReqId": "7B105EDE59C442D585198D501FED3B51",
          "apiReqCols": "",
          "apiReqWhereClause": finalquery,
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
