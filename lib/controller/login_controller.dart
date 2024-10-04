import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/helpers/shared_preferences_helpers.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/model/login_model.dart';
import 'package:pilog_idqm/view/home/home_screen.dart';

class LoginController extends GetxController {
  final userNameText = TextEditingController();
  final passWordText = TextEditingController();
  final userError = false.obs;
  final passError = false.obs;
final isLoading = false.obs; 
  var box;

  LoginController();

  RxBool isUserLoggedIn = RxBool(false);
  RxBool isAnimationComplete = RxBool(false);
  Future<LoginResponse?> signIn(BuildContext context) async {
    context.loaderOverlay.show();
    isUserLoggedIn.value = true;
    String userName = userNameText.text;
    String passWord = passWordText.text;
    LoginResponse? userLoginModel;
    try {
      final response = await ApiServices().requestPostForApi(
        url: "https://kaartech.pilogcloud.com/AR1024228API/appUserLogin",
        dictParameter: {
          "rsUsername": userName.toUpperCase(),
          "rsPassword": passWord,
          "language": "English",
        },
        authToken: false,
      );

      log("status: ${response!.statusCode}");

      if (response.data != null && response.statusCode == 200) {
        userLoginModel = LoginResponse.fromJson(response.data);
        await SharedPreferencesHelper.setIsLoggedIn(true);
        await SharedPreferencesHelper.setUsername(userLoginModel.ssUsername);

        await SharedPreferencesHelper.setRole(userLoginModel.ssRole);

        if (context.mounted) {
          context.loaderOverlay.hide();
        }

        ToastCustom.successToast(
            context, "Welcome ${userLoginModel.ssUsername}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ClientMgrHomeScreen(),
          ),
        );
      } else {
        if (context.mounted) {
          ToastCustom.errorToast(context, "Error occurred, try again later!!");

          if (context.mounted) {
            context.loaderOverlay.hide();
          }
          isUserLoggedIn.value = false;
        }
      }
    } catch (e) {
      if (context.mounted) {
        ToastCustom.errorToast(context, "Error occurred, try again later!!");

        if (context.mounted) {
          context.loaderOverlay.hide();
        }
        isUserLoggedIn.value = false;
      }
    }

    // Return the userLoginModel which can be null if there's an error
    return userLoginModel;
  }
}
