import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_mate_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';

class SigninController extends GetxController {
  //TODO: Implement SigninController

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signin({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = _auth.currentUser!;
      DashboardController controller = Get.put(DashboardController());
      controller.dataUser(user);

      final box = await Hive.openBox('userBox');
      await box.put('isLoggedIn', true);
      // controller.detailCostInit();
      Get.offAllNamed('/dashboard');
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password provided for that user.";
      } else {
        msg = "Error occured, Please fill or check your email and password";
      }
      Get.snackbar(
        "Error occured",
        "Error occured $msg",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
