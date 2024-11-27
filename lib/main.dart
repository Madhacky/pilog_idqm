import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/helpers/init_services.dart';
import 'package:pilog_idqm/view/home/home_screen.dart';
import 'package:pilog_idqm/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await InitServices.injectDependencies();
  // await Hive.initFlutter();
  runApp(const MyApp());
}

SharedPreferences? logindata;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
          ),
          title: "Login App",
          home: const LoaderOverlay(
              useDefaultLoading: true,
             
              child: ClientMgrHomeScreen()),
        ),
      );
    
  }
}
