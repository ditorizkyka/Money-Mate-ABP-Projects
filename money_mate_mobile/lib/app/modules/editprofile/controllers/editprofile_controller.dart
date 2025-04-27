import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

class EditprofileController extends GetxController {
  Future<void> updateUser(String userId, String newName, int limit) async {
    if (newName.isEmpty && limit >= 0) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'limit': limit,
      });
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'limit': limit,
      });
    } else if (limit < 0 && newName.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': newName,
        'limit': limit,
      });
    }
  }

  Future<void> deleteUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();

        var box = await Hive.openBox('userBox');
        box.put('isLoggedIn', false);
      } else {
        print("Tidak ada pengguna yang sedang login");
      }
    } catch (e) {
      print("Error menghapus akun: $e");
    }
  }
}
