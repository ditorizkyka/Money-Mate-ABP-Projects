import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/activities/controllers/activities_controller.dart';
import 'package:frontend/app/shared/constanta.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final limit = 0.obs; // Current limit value
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    var controller = Get.put(ActivitiesController());
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      controller.getActivityById(currentUser.uid);
      controller.getDashboardActivities(currentUser.uid);
      // Load existing limit when controller initializes

      loadUserLimit();
    } else {
      Get.snackbar("Error", "User not logged in");
    }
  }

  /// Load existing user limit from server
  Future<void> loadUserLimit() async {
    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        isLoading.value = true;

        // Fetch user data to get current limit
        final response = await dio.get('http://localhost:8000/api/user/$uid');

        if (response.statusCode == 200 && response.data != null) {
          // Assuming the API returns user data with limit field
          final userData = response.data;
          if (userData['limit'] != null) {
            limit.value = userData['limit'];
          }
        }

        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print("Error loading user limit: $e");
      // Don't show snackbar for this as it's background loading
    }
  }

  /// Set new spending limit
  Future<void> setLimitSpent() async {
    print('Setting limit: ${limit.value}');

    try {
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (uid.isEmpty) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      if (limit.value <= 0) {
        Get.snackbar("Error", "Please enter a valid limit amount");
        return;
      }

      isLoading.value = true;

      // Make API call to update limit
      final response = await dio.put(
        'http://localhost:8000/api/user/$uid',
        data: {'limit': limit.value},
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        print(
          "Limit spent successfully set for user $uid with limit ${limit.value}",
        );
      } else {
        throw Exception('Failed to update limit: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print("Error setting limit: $e");
      Get.snackbar(
        "Error",
        "Failed to set limit: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow; // Rethrow to handle in UI
    }
  }

  /// Update limit value (called from UI)
  void updateLimit(int newLimit) {
    limit.value = newLimit;
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
