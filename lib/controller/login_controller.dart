import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pilog_idqm/helpers/api_services.dart';
import 'package:pilog_idqm/helpers/shared_preferences_helpers.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/model/login_model.dart';
import 'package:pilog_idqm/view/home/home_screen.dart';

class LoginController extends GetxController {
  static late String host_url;
  @override
  void onInit() {
    super.onInit();
    host_url = dotenv.get("HOST_URL");
  }

  final userNameText = TextEditingController();
  final passWordText = TextEditingController();
  final userError = false.obs;
  final passError = false.obs;
  final isLoading = false.obs;

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
        url: "${host_url}appUserLogin",
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
        await SharedPreferencesHelper.setRegion(userLoginModel.ssRegion);
        await SharedPreferencesHelper.setInstance(userLoginModel.ssInstance);



        if (context.mounted) {
          context.loaderOverlay.hide();
          ToastCustom.successToast(
              context, "Welcome ${userLoginModel.ssUsername}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClientMgrHomeScreen(),
            ),
          );
        }
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
