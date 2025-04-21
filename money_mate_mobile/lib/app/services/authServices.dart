import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:money_mate_mobile/app/modules/addcontent/views/addcontent_view.dart';
import 'package:money_mate_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';

class Authservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signup({
    required String email,
    required String password,
    required String fullname,
    required int limit,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection("users").doc(credential.user!.uid).set({
        "name": fullname,
        "email": email,
        "uid": credential.user!.uid,
        "cost": 0,
        "limit": limit,
      });

      Get.offAllNamed('/signin');
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'weak-password') {
        msg = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        msg = "The account already exists for that email.";
      } else {
        msg = "Error occured, Please fill or check it later";
      }
      Get.snackbar(
        "Error occured",
        "Error occured $msg",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signin({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = _auth.currentUser!;
      DashboardController controller = Get.put(DashboardController());
      controller.dataUser(user);

      final box = await Hive.openBox('userBox');
      await box.put('isLoggedIn', true);

      Get.offAllNamed('/dashboard');
    } on FirebaseAuthException catch (e) {
      String msg = '';
      if (e.code == 'user-not-found') {
        msg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        msg = "Wrong password provided for that user.";
      }
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User berhasil sign out");
      var box = await Hive.openBox('userBox');
      box.put('isLoggedIn', false);
      Get.offAllNamed('/signin');
    } catch (e) {
      print("Error saat sign out: $e");
    }
  }
}
