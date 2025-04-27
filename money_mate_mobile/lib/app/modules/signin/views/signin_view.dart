import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/widget/authfield.dart';
import 'package:money_mate_mobile/app/widget/buttonApp.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    Get.lazyPut(() => SigninController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset("assets/images/lastlogo-bg.png", width: 80),
                Gap.h16,
                Text('Hello Momates!', style: TypographyApp.headline1),
                Gap.h8,
                Text('Sign In to your account', style: TypographyApp.text1),
                Gap.h48,
                AuthTextField(
                  title: "Masukan Email Anda",
                  controller: emailController,
                ),
                Gap.h12,
                AuthTextField(
                  title: "Password",
                  controller: passwordController,
                  isObsecure: true,
                ),
                Gap.h12,
                ButtonApp(
                  action: "Sign In",
                  onTap: () async {
                    await controller.signin(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                ),
                Gap.h12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signup');
                      },
                      child: Text('Sign up', style: TypographyApp.text1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
