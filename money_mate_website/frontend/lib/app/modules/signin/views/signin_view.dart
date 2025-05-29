import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/app/widget/authfield.dart';
import 'package:frontend/app/widget/buttonApp.dart';
import 'package:frontend/constant/constant.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // Get.lazyPut(() => SigninController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Left side with blue background
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xFF1A73E8), // Blue color
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/lastlogo-bg.png",
                      width: 120,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Welcome to Money Mate",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        "Your personal finance manager to help you track expenses and reach your financial goals.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right side with sign in form
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(
                    maxWidth: 380,
                  ), // Reduced from 450
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ), // Reduced from 40
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/lastlogo-bg.png",
                        width: 50,
                      ), // Reduced from 60
                      Gap.h12, // Reduced from h16
                      Text(
                        'Hello Momates!',
                        style: TypographyApp.headline1.copyWith(
                          fontSize: 28,
                        ), // Reduced size
                      ),
                      Gap.h4, // Reduced from h8
                      Text(
                        'Sign In to your account',
                        style: TypographyApp.text1.copyWith(
                          fontSize: 14,
                        ), // Added smaller font
                      ),
                      Gap.h32, // Reduced from h48
                      AuthTextField(
                        title: "Masukan Email Anda",
                        controller: emailController,
                      ),
                      Gap.h12, // Reduced from h12
                      AuthTextField(
                        title: "Password",
                        controller: passwordController,
                        isObsecure: true,
                      ),
                      Gap.h12,
                      ButtonApp(
                        action: "Sign In",
                        onTap: () {
                          controller.signin(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          // print("sukses");
                          // Get.offAllNamed('/dashboard');
                        },
                      ),
                      Gap.h8, // Reduced from h12
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/signup');
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ), // Reduced padding
                            ),
                            child: Text(
                              'Sign up',
                              style: TypographyApp.text1.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom compact auth field
}
