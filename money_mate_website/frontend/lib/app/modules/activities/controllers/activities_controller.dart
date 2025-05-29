import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/data/model/Activity.dart';
import 'package:get/get.dart';

class ActivitiesController extends GetxController {
  final count = 0.obs;
  var activities = <Activity>[].obs;
  var top4activities = <Activity>[].obs;
  var isLoading = false.obs;

  // Dio instance
  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();

    // Check if user is logged in before fetching
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Debug API response first (remove this after fixing)
      // debugApiResponse(currentUser.uid);

      getActivityById(currentUser.uid);
    } else {
      Get.snackbar("Error", "User not logged in");
    }
  }

  void _initializeDio() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add interceptor for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  // Method untuk debug response format
  Future<void> debugApiResponse(String uid) async {
    try {
      final response = await _dio.get(
        'http://localhost:8000/api/activities',
        queryParameters: {'firebase_uid': uid},
      );

      print("=== API DEBUG INFO ===");
      print("Status Code: ${response.statusCode}");
      print("Response Type: ${response.data.runtimeType}");
      print("Response Data: ${response.data}");

      if (response.data is Map) {
        final map = response.data as Map<String, dynamic>;
        print("Map Keys: ${map.keys.toList()}");
        map.forEach((key, value) {
          print("Key '$key': ${value.runtimeType} = $value");
        });
      }
      print("=== END DEBUG INFO ===");
    } catch (e) {
      print("Debug error: $e");
    }
  }

  // Method untuk get single activity (diperbaiki)
  Future<void> getActivityById(String activityId) async {
    try {
      isLoading.value = true;
      final response = await _dio.get(
        'http://localhost:8000/api/activities/$activityId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        for (var activity in response.data['data']) {
          activities.add(Activity.fromJson(activity));
        }
        isLoading.value = false;
      } else {
        throw Exception("HTTP ${response.statusCode}: Failed to get activity");
      }
    } on DioException catch (e) {
      log("Dio error: $e");
    } catch (e) {
      log("Get activity error: $e");
      Get.snackbar("Error", "Failed to get activity: ${e.toString()}");
    }
  }

  // Method untuk refresh data
  Future<void> refreshActivities() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await getActivityById(currentUser.uid);
    }
  }

  Future<void> refreshDashboardActivities() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await getDashboardActivities(currentUser.uid);
    }
  }

  // Method untuk get single activity (diperbaiki)
  Future<void> getDashboardActivities(String activityId) async {
    try {
      isLoading.value = true;
      final response = await _dio.get(
        'http://localhost:8000/api/activities/$activityId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        for (var activity in response.data['data']) {
          activities.add(Activity.fromJson(activity));
        }
        // Get top 4 activities
        final sortedActivities = List<Activity>.from(activities);
        sortedActivities.sort(
          (a, b) => b.date.compareTo(a.date),
        ); // urutkan terbaru ke terlama
        top4activities.value = sortedActivities.take(4).toList();
        isLoading.value = false;
      } else {
        throw Exception("HTTP ${response.statusCode}: Failed to get activity");
      }
    } on DioException catch (e) {
      log("Dio error: $e");
    } catch (e) {
      log("Get activity error: $e");
      Get.snackbar("Error", "Failed to get activity: ${e.toString()}");
    }
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
