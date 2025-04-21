import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/services/authServices.dart';
import 'package:money_mate_mobile/app/widget/authfield.dart';
import 'package:money_mate_mobile/app/widget/buttonApp.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController limitController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Image.asset("assets/images/lastlogo-bg.png", width: 60),
                Gap.h12,
                Text('Hello Momates!', style: TypographyApp.headline1),
                Gap.h8,
                Text('Sign-Up to your account', style: TypographyApp.text1),
                Gap.h24,
                AuthTextField(title: "Fullname", controller: nameController),
                Gap.h12,
                AuthTextField(title: "Email", controller: emailController),
                Gap.h12,
                AuthTextField(
                  title: "Password",
                  isObsecure: true,
                  controller: passwordController,
                ),
                Gap.h12,
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Spent Limit"),
                      Gap.h8,
                      TextField(
                        controller: limitController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Rp. 70000",
                          // labelText: "Masukan nama",
                          prefixIcon: Icon(
                            Icons.currency_exchange_outlined,
                            color: ColorApp.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap.h12,
                Gap.h12,
                ButtonApp(
                  action: "Sign-Up",
                  onTap: () async {
                    await Authservices().signup(
                      fullname: nameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      limit:
                          limitController.text == ""
                              ? 0
                              : int.parse(limitController.text),
                    );
                  },
                ),
                Gap.h12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('have an account?'),
                    TextButton(
                      onPressed: () {
                        Get.toNamed('/signin');
                      },
                      child: Text('Sign In', style: TypographyApp.text1),
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
