import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/helpers/init_services.dart';
import 'package:pilog_idqm/view/onboard%20screens/app_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitServices.injectDependencies();
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
      child: ToastificationWrapper(
        child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.purple,
            ),
            title: "Login App",
            home: AppLoader()),
      ),
    );
  }
}
