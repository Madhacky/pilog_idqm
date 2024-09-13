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
    List<Widget> assetCardList = [];
    String reqid = '';
    // String? role = await SharedPreferencesHelper.getRole();
    String? userName = await SharedPreferencesHelper.getUsername();
    String finalquery =
        "UPPER (RECORD_NO) LIKE UPPER ('%$value%')".toUpperCase();

    // if (role == 'PM_FAR_IDAM_CLIENT_MGR') {
    //   reqid = "FEC608B8AA8BB026E0538400000AFD69";
    // } else if (role == 'PM_FAR_IDAM_CLIENT_QC') {
    //   reqid = 'FEC608B8AA89B026E0538400000AFD69';
    // }

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
