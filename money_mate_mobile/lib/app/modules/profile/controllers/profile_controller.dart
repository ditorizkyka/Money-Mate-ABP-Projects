import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  var name = ''.obs;
  var email = ''.obs;
  var isLoading = false.obs;

  Future<void> getData() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      name.value = value.docs[0]['name'];
      email.value = value.docs[0]['email'];
    });

    print(name.value);
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
