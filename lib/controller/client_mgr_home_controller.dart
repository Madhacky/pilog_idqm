import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/helpers/shared_preferences_helpers.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/view/home/components/asset_data_card.dart';
import 'package:pilog_idqm/view/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientMgrHomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static late String host_url;
  // Animation controllers
  late Animation<double> animation;
  late AnimationController animationController;

  // Text editing controller
  TextEditingController searchController = TextEditingController();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var area = ''.obs;
  var country = ''.obs;
  var city = ''.obs;

  late GoogleMapController googleMapController;

  // Get current location and permissions
  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Get placemark information
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.first;

    // Update state
    latitude.value = position.latitude;
    longitude.value = position.longitude;
    area.value = place.subLocality ?? '';
    country.value = place.country ?? '';
    city.value = place.locality ?? '';
  }

  // Method to set GoogleMapController
  void setGoogleMapController(GoogleMapController controller) {
    googleMapController = controller;
  }

  // Method to animate the camera to a new position
  void animateCameraTo(LatLng position, double zoom) {
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: zoom),
      ),
    );
  }

  // Update marker position when dragged
  void updateMarkerPosition(LatLng newPosition) {
    latitude.value = newPosition.latitude;
    longitude.value = newPosition.longitude;
  }

  // Bools
  RxBool isAssetDataLoaded = RxBool(false);
  late Future getAssetdataFuture;
  late Future getImgFuture;
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
    //  toggleAnimation();
    logoutAPI(context);
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
  List<Widget> assetCardList = [];
  Future getAssetData({
    required String value,
    required int offset,
    required int rows,
  }) async {
    assetCardList.clear();
    String finalquery =
        "UPPER (CLASS_TERM) LIKE UPPER ('$value') OR UPPER (BU_DH_CUST_COL53) LIKE UPPER ('$value') OR UPPER (RECORD_NO) LIKE UPPER ('$value') AND RECORD_NO IS NOT NULL OFFSET $offset ROWS FETCH NEXT $rows ROWS ONLY";

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
    // final String host_url = "https://ifar.pilogcloud.com/";
    // final String reqid = "6085DAB947664BEAB39921AC425BB71A";
    // final String orgnId = "C1F5CFB03F2E444DAE78ECCEAD80D27D";
    // final String username =
    //     (await SharedPreferencesHelper.getUsername())!.toUpperCase();

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      "apiReqId": "6085DAB947664BEAB39921AC425BB71A",
      "apiReqCols": "",
      "apiReqWhereClause": "RECORD_NO = '$recordNo'",
      "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
      "apiReqUserId": "KT_VBR_MGR",
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

//upload image

// Function to upload image to API
  Future<void> uploadImageApi(
      File? file, String recordNumber, BuildContext context) async {
    context.loaderOverlay.show();
    // Convert XFile to File
    //File file = File(xfile!.path);
    log(base64Encode(file!.readAsBytesSync()));
    int randomNo = math.Random().nextInt(1000);
    String filename = "${recordNumber}_img_${randomNo.toString()}.jpg";

    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({
      "apiReqId": "855A9F8A5A0A43E1BCD2A5C12546AB91",
      "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
      "apiAttachFalg": "Y",
      "apiUpdateFalg": "",
      "apiInsertFalg": "",
      "apiDeleteFalg": "",
      "apiReqUserId": "KT_VBR_MGR",
      "855A9F8A5A0A43E1BCD2A5C12546AB91": [
        {
          "ACTIVE_FLAG": "Y",
          "FILE_NAME": filename,
          "REGION": "IN",
          "LOCALE": "en_US",
          "DEFAULT_FLAG": "N",
          "ATTACH_TYPE": "Image",
          "CONTENT": base64Encode(file.readAsBytesSync()),
          "ATTACH_EXTENSION": "jpg",
          "TYPE": "P",
          "RECORD_NO": recordNumber
        }
      ]
    });

    try {
      var response = await http.post(
        Uri.parse('${host_url}updateInsertApiRequestData'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          context.loaderOverlay.hide();
          ToastCustom.successToast(context, "Uploaded Successfully");
        }
        print("Upload successful: ${response.body}");
      } else {
        if (context.mounted) {
          context.loaderOverlay.hide();
          ToastCustom.errorToast(context, "Uploaded failed");
        }
        print("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

//delete image api
  Future<void> imageDeleteApi(
      String auditID, String recordNo, BuildContext context) async {
    context.loaderOverlay.show();

    var dictParameter = {
      "apiReqId": "9B7DB8414A274A0EB1133E5FFF9F3BAC",
      "apiReqOrgnId": "1F026AB672B2B6C0E0630400010AF3F9",
      "apiAttachFlag": "",
      "apiUpdateFalg": "",
      "apiInsertFalg": "",
      "apiDeleteFalg": "Y",
      "apiReqUserId": "KT_VBR_MGR",
      "9B7DB8414A274A0EB1133E5FFF9F3BAC": [
        {"AUDIT_ID": auditID, "RECORD_NO": recordNo}
      ]
    };

    // Call the requestPostForApi method
    var response = await ApiServices().requestPostForApi(
      url: '${host_url}updateInsertApiRequestData',
      dictParameter: dictParameter,
      authToken: false, // Adjust as needed for your auth token requirement
    );

    if (response != null && response.statusCode == 200) {
      if (context.mounted) {
        ToastCustom.successToast(context, "Deleted Successfully");
        context.loaderOverlay.hide();
        Navigator.pop(context);
      }
    } else {
      if (context.mounted) {
        ToastCustom.errorToast(context, "Failed to delete");
        context.loaderOverlay.hide();
        Navigator.pop(context);
      }
    }
  }

//parametric search 
Future<void> parametricSearchApi(String auditID, BuildContext context) async {}


  //logout api
  Future<void> logoutAPI(
    BuildContext context,
  ) async {
    Get.deleteAll();
    await SharedPreferencesHelper.clearAll();
    Navigator.pushReplacement(
        context, CupertinoPageRoute<bool>(builder: (_) => LoginScreen()));
    Fluttertoast.showToast(
      msg: "Thank You",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromRGBO(11, 74, 153, 1),
      textColor: Colors.white,
      fontSize: 16.0,
    );
    //   var headers = {'Content-Type': 'application/json'};
    //   var body = json.encode({"rsUsername":await SharedPreferencesHelper.getUsername()});

    //   try {
    //     var response = await http.post(
    //       Uri.parse(host_url + 'appUserlogout'),
    //       headers: headers,
    //       body: body,
    //     );

    //     if (response.body == 'Success') {

    //       Get.deleteAll();
    //       await SharedPreferencesHelper.clearAll();
    //       Navigator.pushReplacementNamed(context, '/login');
    //       Fluttertoast.showToast(
    //         msg: "Thank You",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.SNACKBAR,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Color.fromRGBO(11, 74, 153, 1),
    //         textColor: Colors.white,
    //         fontSize: 16.0,
    //       );
    //     } else {
    //       Fluttertoast.showToast(
    //         msg: response.reasonPhrase ?? 'Logout Failed',
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.SNACKBAR,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0,
    //       );
    //     }
    //   } catch (e) {
    //     Fluttertoast.showToast(
    //       msg: e.toString(),
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.SNACKBAR,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0,
    //     );
    //   }
  }
}
