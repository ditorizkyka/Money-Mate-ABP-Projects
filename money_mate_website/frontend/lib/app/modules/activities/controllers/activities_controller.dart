import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/data/model/Activity.dart';
import 'package:get/get.dart';

class ActivitiesController extends GetxController {
  var activities = <Activity>[].obs;
  var top4activities = <Activity>[].obs;
  var isLoading = false.obs;
  var totalSpent = 0.obs;
  var top4HighSpentActivities = <Activity>[].obs;

  // Grouped activities by type
  var activitiesByType = <String, List<Activity>>{}.obs;

  // Total spent per type
  var totalSpentByType =
      <String, int>{'education': 0, 'travel': 0, 'item': 0, 'other': 0}.obs;

  // Di dalam controller
  var percentageByType =
      <String, double>{
        'education': 0.0,
        'travel': 0.0,
        'item': 0.0,
        'other': 0.0,
      }.obs;

  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _initializeDio();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      getActivityById(currentUser.uid);
    } else {
      Get.snackbar("Error", "User not logged in");
    }
  }

  void _initializeDio() {
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

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
        activities.clear();
        totalSpent.value = 0;

        for (var activity in response.data['data']) {
          final newActivity = Activity.fromJson(activity);
          activities.add(newActivity);
          totalSpent.value += newActivity.spent;
        }

        groupActivitiesByType(); // Pemanggilan metode pemisah dan perhitungan
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
        activities.clear();
        totalSpent.value = 0;

        for (var activity in response.data['data']) {
          final newActivity = Activity.fromJson(activity);
          activities.add(newActivity);
          totalSpent.value += newActivity.spent;
        }

        final sortedActivities = List<Activity>.from(activities);
        sortedActivities.sort((a, b) => b.date.compareTo(a.date));
        top4activities.value = sortedActivities.take(4).toList();

        getTop4HighSpentActivities(); // ← Tambahkan ini
        groupActivitiesByType();
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

  // Metode untuk mengelompokkan activity dan menghitung total spent per type
  void groupActivitiesByType() {
    final Map<String, List<Activity>> grouped = {};
    final Map<String, int> spentByType = {
      'education': 0,
      'travel': 0,
      'item': 0,
      'other': 0,
    };

    for (var activity in activities) {
      final type = activity.type.toLowerCase();

      if (!grouped.containsKey(type)) {
        grouped[type] = [];
      }
      grouped[type]!.add(activity);

      if (spentByType.containsKey(type)) {
        spentByType[type] = spentByType[type]! + activity.spent;
      } else {
        spentByType[type] = activity.spent;
      }
    }

    activitiesByType.value = grouped;
    totalSpentByType.value = spentByType;

    final int total = totalSpent.value;
    final Map<String, double> tempPercentage = {};

    spentByType.forEach((type, value) {
      if (total > 0) {
        tempPercentage[type] = (value / total) * 100;
      } else {
        tempPercentage[type] = 0.0;
      }
    });

    percentageByType.value = tempPercentage;
  }

  void getTop4HighSpentActivities() {
    final sorted = List<Activity>.from(activities);
    sorted.sort((a, b) => b.spent.compareTo(a.spent)); // Descending
    top4HighSpentActivities.value = sorted.take(4).toList();
  }

  @override
  void onClose() {
    _dio.close();
    super.onClose();
  }
}
