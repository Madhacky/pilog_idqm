import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/helpers/shared_preferences_helpers.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientMgrHomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static late String host_url;
  // Animation controllers
  late Animation<double> animation;
  late AnimationController animationController;

  // Text editing controller
  TextEditingController searchController = TextEditingController();

  // Bools
  RxBool isAssetDataLoaded = RxBool(false);
  late Future getAssetdataFuture;
  var logindata;
  var Finaldata;

  @override
  void onInit() {
    super.onInit();
    host_url = dotenv.get("HOST_URL");
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void toggleAnimation() {
    if (animationController.isCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  void onParametricSearch(context) {
    toggleAnimation();
  }

  void onLogout(BuildContext context) {
    toggleAnimation();
    logoutAPI(context, logindata);
    // Handle Logout action here
  }

  onTapSearch() async {
    String? username = await SharedPreferencesHelper.getRole();
    isAssetDataLoaded.value = true;
    log("shared : $username");
    getAssetdataFuture =
        getAssetData(offset: 0, rows: 10, value: searchController.text);
    update();
  }

  // APIS
  Future getAssetData({
    required String value,
    required int offset,
    required int rows,
  }) async {
    final String host_url = "https://ifar.pilogcloud.com/";
    List<Widget> assetCardList = [];
    String reqid = '';
    String? role = await SharedPreferencesHelper.getRole();
    String? userName = await SharedPreferencesHelper.getUsername();
    String finalquery =
        "UPPER (MASTER_COLUMN6) LIKE UPPER ('%$value%') AND RECORD_NO IS NOT NULL OFFSET $offset ROWS FETCH NEXT $rows ROWS ONLY"
            .toUpperCase();

    if (role == 'PM_FAR_IDAM_CLIENT_MGR') {
      reqid = "FEC608B8AA8BB026E0538400000AFD69";
    } else if (role == 'PM_FAR_IDAM_CLIENT_QC') {
      reqid = 'FEC608B8AA89B026E0538400000AFD69';
    }

    try {
      final response = await ApiServices().requestPostForApi(
        url: "${host_url}getApiRequestResultsData",
        dictParameter: {
          "apiReqId": reqid,
          "apiReqCols": "",
          "apiReqWhereClause": finalquery,
          "apiReqOrgnId": "C1F5CFB03F2E444DAE78ECCEAD80D27D",
          "apiReqUserId": userName!.toUpperCase(),
          "apiRetType": "JSON"
        },
        authToken: false,
      );

      log("status ${response?.statusCode}");
      if (response?.statusCode == 200) {
        var result = jsonDecode(response!.data.toString());
        for (var object in result!['apiDataArray']) {
          assetCardList.add(AssetDataCard(
            tag: object["BU_DH_CUST_COL37"],
            condition: object["CONDITION_MEANING"],
            adminBuilding: object["BU_DH_CUST_COL25"],
            entityName: object["BU_DH_CUST_COL18"],
            data: object["BU_DH_CUST_COL30"],
            title: object["ABBREVIATION"],
            wave: object["REGISTER_COLUMN5"],
            omDepartment: object["BU_DH_CUST_COL30"],
            locationPriority: object["BU_DH_CUST_COL57"],
            complexName: object["BU_DH_CUST_COL58"],
            floorLevel: object["BU_DH_CUST_COL52"],
            floorLevelName: object["BU_DH_CUST_COL61"],
            spaceLocation: object["BU_DH_CUST_COL20"],
            spaceLocationName: object["BU_DH_CUST_COL22"],
            assertDescription: object["MASTER_COLUMN6"],
            asserTitle: object["ASSET_PRODUCT_TITLE"],
            pgGrade: object["BU_DH_CUST_COL39"],
            pgGradeName: object["CONDITION_MEANING"],
            fieldComments: object["FIELD_COMMENTS"],
            recordNo: object["RECORD_NO"],
            areaId: object["ASSET_AREA_ID"],
            areaName: object["CUSTOM_DH_COLUMN8"],
            astOrgId: object["ASSET_ORG_ID"],
            cityId: object["ASSET_CITY_ID"],
            cityName: object["CUSTOM_DH_COLUMN7"],
            districtId: object["ASSET_DISTRICT_ID"],
            districtName: object["CUSTOM_DH_COLUMN9"],
            geoLocation: object["BU_DH_CUST_COL34"],
            geoMapLink: object["BU_DH_CUST_COL33"],
            gisLinkId: object["BU_DH_CUST_COL57"],
            gisLocator: object["BU_DH_CUST_COL53"],
            orgName: object["CUSTOM_DH_COLUMN5"],
            regionId: object["ASSET_REGION_ID"],
            regionName: object["CUSTOM_DH_COLUMN6"],
            sectionId: object["ASSET_SEC_ID"],
            sectionName: object["CUSTOM_DH_COLUMN10"],
            asBuiltRef: object["BU_DH_CUST_COL29"],
            assetQty: object["BU_DH_CUST_COL38"],
            assetVariantDescription: object["MASTER_COLUMN5"],
            uniClassSlCode: object["BU_DH_CUST_COL21"],
            uniClassSlTitle: object["ASSET_SPACE_TITLE"],
            uniClassCode: object["CUSTOM_DH_COLUMN13"],
            uniClassTitle: object["ASSET_COMPLEX_NAME"],
            functionalClassification: object["BU_DH_CUST_COL25"],
            uniEnCode: object["CUSTOM_DH_COLUMN15"],
            uniEnTitle: object["ASSET_ENTITY_NAME"],
            surveyedBy: object["SURVEYED_BY"],
            surveyedDate: object["SURVEYED_DATE"],
            internalQcBy: object["INTERNAL_QC_BY"],
            internalQcDate: object["INTERNAL_QC_DATE"],
            clientQcBy: object["CLIENT_QC_BY"],
            clientQcDate: object["CLIENT_QC_DATE"],
            clientQcStatus: object["MASTER_COLUMN14"],
            clientQcCommets: object["MASTER_COLUMN13"],
            submissionTo: object["SUBMISSION_TO"],
            submissionDATE: object["SUBMISSION_DATE"],
            drawingName: object["DRAWING_NAME"],
            drawingNumber: object["DRAWING_NUMBER"],
            drawingType: object["DRAWING_TYPE"],
            drawingRev: object["DRAWING_REV"],
            existTagNumber: object["BU_DH_CUST_COL35"],
            manufactureYear: object["CUSTOM_DH_COLUMN1_DATE"],
            manufacture: object["BU_DH_CUST_COL46"],
            model: object["BU_DH_CUST_COL51"],
            pinNumber: object["BU_DH_CUST_COL45"],
          ));
        }
        log("adataaaaaa ${result!['apiDataArray'][0]["ASSET_COMPLEX_NAME"]}");
        return assetCardList;
      } else {
        return Future.error('Error: ${response?.statusCode}');
      }
    } catch (e) {
      log("error $e");
      return Future.error(e.toString());
    }
  }

  Future<void> updateClientMgrQcRecord({
    required String recordNo,
    required String masterColumn14,
    required String masterColumn13,
  }) async {
    final String host_url = "https://ifar.pilogcloud.com/";
    final String reqid = "FEC608B8AA8EB026E0538400000AFD69";
    final String orgnId = "C1F5CFB03F2E444DAE78ECCEAD80D27D";
    final String username =
        (await SharedPreferencesHelper.getUsername())!.toUpperCase();

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      "apiReqId": reqid,
      "apiReqCols": {
        "RECORD_NO": recordNo,
        "MASTER_COLUMN14": masterColumn14,
        "MASTER_COLUMN13": masterColumn13,
      },
      "apiReqWhereClause": "RECORD_NO='$recordNo'",
      "apiReqOrgnId": orgnId,
      "apiReqUserId": username,
      "apiRetType": "JSON"
    });

    var response = await http.post(
      Uri.parse("${host_url}updateApiRequestResultsData"),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      log("Update Successful: $result");
    } else {
      log("Error: ${response.statusCode}");
    }
  }

  Future<dynamic> DisplayImage({required String recordNo}) async {
    final String host_url = "https://ifar.pilogcloud.com/";
    final String reqid = "6085DAB947664BEAB39921AC425BB71A";
    final String orgnId = "C1F5CFB03F2E444DAE78ECCEAD80D27D";
    final String username =
        (await SharedPreferencesHelper.getUsername())!.toUpperCase();

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      "apiReqId": reqid,
      "apiReqCols": "",
      "apiReqWhereClause": "RECORD_NO = '$recordNo'",
      "apiReqOrgnId": orgnId,
      "apiReqUserId": username,
      "apiRetType": "JSON"
    });

    var response;
    try {
      response = await http.post(
        Uri.parse(host_url + 'getApiRequestResultsData'),
        headers: headers,
        body: body,
      );
    } catch (e) {
      log("API call error: $e");
      return Future.error("API call error: $e");
    }

    if (response.statusCode == 200) {
      try {
        Finaldata = jsonDecode(response.body);
        print("Image Data: ${Finaldata['apiDataArray']}");
        return Finaldata;
      } catch (e) {
        log("JSON decode error: $e");
        return Future.error("JSON decode error: $e");
      }
    } else {
      log("Error: ${response.reasonPhrase}");
      return Future.error("Error: ${response.reasonPhrase}");
    }
  }

  //logout api
  Future<void> logoutAPI(
      BuildContext context, SharedPreferences logindata) async {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({"rsUsername": logindata.getString('username')});

    try {
      var response = await http.post(
        Uri.parse(host_url + 'appUserlogout'),
        headers: headers,
        body: body,
      );

      if (response.body == 'Success') {
        logindata.setBool('login', true);
        Get.deleteAll();
        await SharedPreferencesHelper.clearAll();
        Navigator.pushReplacementNamed(context, '/login');
        Fluttertoast.showToast(
          msg: "Thank You",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromRGBO(11, 74, 153, 1),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.reasonPhrase ?? 'Logout Failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
