import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pilog_idqm/controller/login_controller.dart';
import 'package:pilog_idqm/helpers/toasts.dart';
import 'package:pilog_idqm/view/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final LoginController controller =
      Get.put(LoginController());




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 30),
                  Image(
                    height: 200,
                    image: AssetImage("assets/Images/loginlogo.gif"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Please login to your account',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  buildLoginForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black87, Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(
        painter: BackgroundPainter(),
        child: Container(),
      ),
    );
  }

  Widget buildLoginForm() {
    return Card(
      elevation: 8.0,
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
        fillColor: Colors.grey[200],
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(25.0),
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
        fillColor: Colors.grey[200],
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(25.0),
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
        Future.delayed(Duration(seconds: 2),(){
          Get.to(ClientMgrHomeScreen());
        });
        // if (controller.userNameText.text.isEmpty ||
        //     controller.passWordText.text.isEmpty) {
        //   ToastCustom.errorToast(context, "Please enter username and password");
        // } else {
        //   await controller.signIn(context);
        // }
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

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.6,
          size.width * 0.5, size.height * 0.7)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.8, size.width, size.height * 0.7)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
