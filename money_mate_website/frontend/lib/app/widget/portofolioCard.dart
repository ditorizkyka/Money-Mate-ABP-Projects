import 'package:flutter/material.dart';
import 'package:frontend/app/modules/activities/controllers/activities_controller.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';

class PortofolioCard extends StatelessWidget {
  const PortofolioCard({super.key});

  @override
  Widget build(BuildContext context) {
    ActivitiesController activityController = Get.put(ActivitiesController());
    return Container(
      height: SizeApp.customHeight(270),
      padding: EdgeInsets.all(24),
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
              Text(
                'Portfolio',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.arrow_outward, size: 20, color: Colors.grey[600]),
            ],
          ),
          SizedBox(height: 20),

          // Portfolio Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  'Rp${activityController.totalSpent.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                ' 00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
            child: Obx(() {
              final activitiesController = Get.find<ActivitiesController>();

              return Row(
                children: [
                  Expanded(
                    flex:
                        activitiesController.percentageByType['education']
                            ?.toInt() ??
                        0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorApp.mainColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomLeft: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex:
                        activitiesController.percentageByType['travel']
                            ?.toInt() ??
                        0,
                    child: Container(color: Color(0xFFEC4899)),
                  ),
                  Expanded(
                    flex:
                        activitiesController.percentageByType['item']
                            ?.toInt() ??
                        0,
                    child: Container(color: Color(0xFF06B6D4)),
                  ),
                  Expanded(
                    flex:
                        activitiesController.percentageByType['other']
                            ?.toInt() ??
                        0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF59E0B),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          SizedBox(height: 16),

          // Categories
          Obx(() {
            final activitiesController = Get.find<ActivitiesController>();
            final spent = activitiesController.totalSpentByType;
            return spent.isEmpty
                ? Center(child: Text('No data available'))
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryItem(
                      'Rp${activityController.totalSpentByType['education']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') ?? '0'}',
                      'Education',
                      ColorApp.mainColor,
                    ),
                    _buildCategoryItem(
                      'Rp${activityController.totalSpentByType['travel']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') ?? '0'}',
                      'Travel',
                      Color(0xFFEC4899),
                    ),
                    _buildCategoryItem(
                      'Rp${activityController.totalSpentByType['item']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') ?? '0'}',
                      'Item',
                      Color(0xFFF59E0B),
                    ),
                    _buildCategoryItem(
                      'Rp${activityController.totalSpentByType['other']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') ?? '0'}',
                      'Other',
                      Color(0xFF06B6D4),
                    ),
                  ],
                );
          }),
          SizedBox(height: 20),

          // Stats
          Row(
            children: [
              _buildStatItem('▲ 24%', 'Received', Colors.green),
              SizedBox(width: 24),
              _buildStatItem('▲ 19%', 'Expected', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String amount, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 6),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String percentage, String label, Color color) {
    return Row(
      children: [
        Text(
          percentage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}
