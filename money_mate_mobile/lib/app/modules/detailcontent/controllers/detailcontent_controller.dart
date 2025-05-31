import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DetailcontentController extends GetxController {
  //TODO: Implement DetailcontentController

  var isExpandedList = <RxBool>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var totalBarang = 0.obs;
  var totalPendidikan = 0.obs;
  var totalTravel = 0.obs;

  ExpandableListController(int itemCount) {
    isExpandedList.assignAll(List.generate(itemCount, (_) => false.obs));
  }

  void toggleExpand(int index) {
    isExpandedList[index].toggle();
  }

  void fetchActivities() async {
    var snapshot = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('activity')
        .get();

    int barang = 0, pendidikan = 0, travel = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data();
      String type = data['type'] ?? '';
      int cost = int.tryParse(data['cost'].toString()) ?? 0;

      if (type == 'Barang') {
        barang += cost;
      } else if (type == 'Pendidikan') {
        pendidikan += cost;
      } else if (type == 'Travel') {
        travel += cost;
      }
    }

    totalBarang.value = barang;
    totalPendidikan.value = pendidikan;
    totalTravel.value = travel;
  }
}
