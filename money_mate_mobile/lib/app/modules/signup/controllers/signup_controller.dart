import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // for authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //TODO: Implement SignupController

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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .collection('detailCost')
          .doc('fixedDocument') // Menggunakan doc() untuk menentukan ID dokumen
          .set({'barang': 0, 'pendidikan': 0, 'travel': 0});

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
}
