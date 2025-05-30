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
    final ActivitiesController controller = Get.put(ActivitiesController());
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
                    'Highest Spent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Track your 4 Highest Spent activities',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Obx(() {
            final ActivitiesController controller = Get.put(
              ActivitiesController(),
            );
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SizedBox(
                height: SizeApp.customHeight(260),
                child: ListView.builder(
                  itemCount: controller.top4HighSpentActivities.length,
                  itemBuilder: (context, index) {
                    final activity = controller.top4HighSpentActivities[index];
                    return ActivitiesItem(
                      title: activity.name,
                      subtitle: activity.description,
                      amount: '+ Rp${activity.spent.toStringAsFixed(2)}',
                      date: activity.date.toString().split(' ')[0],
                      bgColor: _getBackgroundColor(activity.type),
                      iconColor: _getIconColor(activity.type),
                      icon: _getIconByType(activity.type),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Color _getBackgroundColor(String type) {
    switch (type.toLowerCase()) {
      case 'education':
        return Colors.blue[50]!;
      case 'travel':
        return Colors.pink[50]!;
      case 'item':
        return Colors.orange[50]!;
      case 'other':
        return Colors.cyan[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getIconColor(String type) {
    switch (type.toLowerCase()) {
      case 'education':
        return Colors.blue;
      case 'travel':
        return Colors.pink;
      case 'item':
        return Colors.orange;
      case 'other':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'item':
        return Icons.shopping_cart;
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.help_outline;
    }
  }
}
