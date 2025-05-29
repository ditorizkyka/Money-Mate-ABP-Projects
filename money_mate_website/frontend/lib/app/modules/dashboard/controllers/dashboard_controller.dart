import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/modules/activities/controllers/activities_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  //TODO: Implement DashboardController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    var controller = Get.put(ActivitiesController());
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Debug API response first (remove this after fixing)
      // debugApiResponse(currentUser.uid);

      controller.getActivityById(currentUser.uid);
    } else {
      Get.snackbar("Error", "User not logged in");
    }
    // Example call to fetch activities
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
