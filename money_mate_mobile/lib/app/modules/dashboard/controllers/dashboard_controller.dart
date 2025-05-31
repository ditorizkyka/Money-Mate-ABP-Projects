import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:money_mate_mobile/app/data/model/user.dart';

class DashboardController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxInt selectedIndex = 0.obs;

  UserModel user = UserModel(email: 'L2O8f@example.com', uid: '123456789');

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void dataUser(User userFirebase) async {
    await _firestore.collection('users').doc(userFirebase.uid).get().then((
      value,
    ) {
      print(value.exists);
      user.name = value['name'];
      user.cost = value['cost'];
    });
    user.email = userFirebase.email!;
    user.uid = userFirebase.uid;
  }

  // Future<void> detailCostInit() async {
  //   String userId = FirebaseAuth.instance.currentUser!.uid;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('detailCost')
  //       .doc('fixedDocument') // Menggunakan doc() untuk menentukan ID dokumen
  //       .set({'barang': 0, 'pendidikan': 0, 'travel': 0});
  // }
}
