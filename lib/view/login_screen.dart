import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pilog_idqm/controller/login_controller.dart';
import 'package:pilog_idqm/view/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Image(
                height: 90,
                image: AssetImage("assets/images/PiLog Logo.png"),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please login to your account',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 40),
              buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildUserNameField(),
            const SizedBox(height: 20),
            buildPasswordField(),
            const SizedBox(height: 20),
            Obx(() => buildErrorMessages()),
            const SizedBox(height: 20),
            buildLoginButton(),
          ],
        ),
      ),
    );
  }

  Widget buildUserNameField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (value) {
        controller.userError.value = false;
        controller.passError.value = false;
      },
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: 'User Name',
        labelStyle: TextStyle(color: Colors.blueGrey),
        fillColor: Colors.grey[100],
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      controller: controller.userNameText,
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      obscureText: true,
      style: const TextStyle(color: Colors.black87),
      onChanged: (value) {
        controller.userError.value = false;
        controller.passError.value = false;
      },
      controller: controller.passWordText,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.blueGrey),
        fillColor: Colors.grey[100],
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  Widget buildErrorMessages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.userError.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Invalid credentials. Please check Username and try again.',
              style: TextStyle(color: Colors.red),
            ),
          ),
        if (controller.passError.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Invalid credentials. Please check Password and try again.',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }

  Widget buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        // Simple animation effect
        Get.focusScope!.unfocus(); // Close the keyboard
        Future.delayed(Duration(seconds: 1), () {
          Get.to(ClientMgrHomeScreen());
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: const Text('Login'),
    );
  }
}

