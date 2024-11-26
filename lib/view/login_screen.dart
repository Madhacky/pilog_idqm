import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
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
    // Get screen size for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width >= 600;
    
    return LoaderOverlay(
      useDefaultLoading: true,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              // Responsive padding based on screen width
              horizontal: screenSize.width * 0.05,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              // Constrain the maximum width for larger screens
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(  
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  // Responsive image size
                  Image(
                    height: isTablet ? 80 : 60,
                    image: const AssetImage("assets/images/PiLog Logo.png"),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please login to your account',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildLoginForm(isTablet),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm(bool isTablet) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildUserNameField(isTablet),
            const SizedBox(height: 16),
            buildPasswordField(isTablet),
            const SizedBox(height: 16),
            Obx(() => buildErrorMessages()),
            const SizedBox(height: 16),
            buildLoginButton(isTablet),
          ],
        ),
      ),
    );
  }

  Widget buildUserNameField(bool isTablet) {
    return SizedBox(
      height: isTablet ? 45 : 40, // Smaller height for the text field
      child: TextFormField(
        keyboardType: TextInputType.text,
        onChanged: (value) {
          controller.userError.value = false;
          controller.passError.value = false;
        },
        style: TextStyle(
          color: Colors.black87,
          fontSize: isTablet ? 14 : 13, // Smaller font size
        ),
        decoration: InputDecoration(
          labelText: 'User Name',
          labelStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: isTablet ? 14 : 13, // Smaller label size
          ),
          fillColor: Colors.grey[100],
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8, // Reduced vertical padding
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8.0), // Smaller border radius
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0), // Smaller border radius
          ),
        ),
        controller: controller.userNameText,
      ),
    );
  }

  Widget buildPasswordField(bool isTablet) {
    return SizedBox(
      height: isTablet ? 45 : 40, // Smaller height for the text field
      child: TextFormField(
        obscureText: true,
        style: TextStyle(
          color: Colors.black87,
          fontSize: isTablet ? 14 : 13, // Smaller font size
        ),
        onChanged: (value) {
          controller.userError.value = false;
          controller.passError.value = false;
        },
        controller: controller.passWordText,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            color: Colors.blueGrey,
            fontSize: isTablet ? 14 : 13, // Smaller label size
          ),
          fillColor: Colors.grey[100],
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8, // Reduced vertical padding
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(8.0), // Smaller border radius
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0), // Smaller border radius
          ),
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
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: const Text(
              'Invalid credentials. Please check Username and try again.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (controller.passError.value)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: const Text(
              'Invalid credentials. Please check Password and try again.',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget buildLoginButton(bool isTablet) {
    return SizedBox(
      height: isTablet ? 45 : 40, // Smaller height for the button
      child: ElevatedButton(
        onPressed: () async {
          controller.signIn(context);
          Get.focusScope!.unfocus(); // Close the keyboard
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Smaller border radius
          ),
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero, // Remove default padding
          textStyle: TextStyle(
            fontSize: isTablet ? 15 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: const Text('Login'),
      ),
    );
  }
}