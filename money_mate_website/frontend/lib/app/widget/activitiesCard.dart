import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/activities/controllers/activities_controller.dart';
import 'package:frontend/app/widget/activitiesItem.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';

class ActivitiesCard extends StatelessWidget {
  const ActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    Get.lazyPut(() => ActivitiesController());
    final ActivitiesController controller = Get.find<ActivitiesController>();
    controller.getDashboardActivities(
      FirebaseAuth.instance.currentUser?.uid ?? '',
    );
    return Container(
      // height: SizeApp.customHeight(370),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Track you 3 recent activities',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => controller.refreshActivities(),
                child: Icon(Icons.refresh, size: 20, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            height: SizeApp.customHeight(260),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.top4activities.isEmpty) {
                return const Center(child: Text("No activities found"));
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshDashboardActivities(),
                child: ListView.builder(
                  itemCount: controller.top4activities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.top4activities[index];
                    return ActivitiesItem(
                      title: activity.name,
                      subtitle: activity.description,
                      amount: '+ ₹ ${activity.spent.toStringAsFixed(2)}',
                      date: activity.date.toString().split(' ')[0],
                      bgColor: Colors.blue[50]!,
                      iconColor: Colors.blue,
                      icon: Icons.arrow_upward,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
