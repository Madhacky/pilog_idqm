import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:loader_overlay/loader_overlay.dart';
import 'package:pilog_idqm/controller/client_mgr_home_controller.dart';
import 'package:pilog_idqm/helpers/init_services.dart';
import 'package:pilog_idqm/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await InitServices.injectDependencies();
  // await Hive.initFlutter();
  runApp(const MyApp());
}

SharedPreferences? logindata;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityAppWrapper(
      app: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.purple,
          ),
          title: "Login App",
          home: LoaderOverlay(
              useDefaultLoading: false,
              overlayWidgetBuilder: (_) {
                return const Center(
                  child: SpinKitCircle(
                    color: Colors.white,
                    size: 50.0,
                  ),
                );
              },
              child: SplashScreen()),
        ),
      ),
    );
  }
}
