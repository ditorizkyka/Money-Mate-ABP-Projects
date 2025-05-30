import 'package:flutter/material.dart';
import 'package:frontend/app/modules/dashboard/views/dashboard_view.dart';
import 'package:frontend/app/widget/activitiesItem.dart';
import 'package:frontend/app/widget/categoryCard.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';
import '../controllers/activities_controller.dart';

class ActivitiesView extends GetView<ActivitiesController> {
  const ActivitiesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(),
              Gap.h12,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Always save your money by recap your activities',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Member Since April 20, 2023',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Grid Layout
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              // Portfolio Card
                              Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Activities',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            Text(
                                              'Track your activities',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_outward,
                                          size: 20,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    // LOOPING
                                    SizedBox(
                                      height: 500,
                                      child: Obx(() {
                                        if (controller.isLoading.value) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        if (controller.activities.isEmpty) {
                                          return const Center(
                                            child: Text("No activities found"),
                                          );
                                        }

                                        return RefreshIndicator(
                                          onRefresh:
                                              () =>
                                                  controller
                                                      .refreshActivities(),
                                          child: ListView.builder(
                                            itemCount:
                                                controller.activities.length,
                                            itemBuilder: (context, index) {
                                              final activity =
                                                  controller.activities[index];
                                              return ActivitiesItem(
                                                title: activity.name,
                                                subtitle: activity.description,
                                                amount:
                                                    '+ Rp${activity.spent.toStringAsFixed(2)}',
                                                date:
                                                    activity.date
                                                        .toString()
                                                        .split(' ')[0],
                                                bgColor: _getBackgroundColor(
                                                  activity.type,
                                                ),
                                                iconColor: _getIconColor(
                                                  activity.type,
                                                ),
                                                icon: _getIconByType(
                                                  activity.type,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                    ),

                                    // Transaction Items
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),

                              // Investment Wallet & Borrowing Row
                            ],
                          ),
                        ),
                        SizedBox(width: 20),

                        // Right Column
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              // Category Cards
                              Obx(() {
                                final spent = controller.totalSpentByType;

                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Categorycard(
                                  title: 'Education',
                                  amount: spent['education'] ?? 0,
                                  color1: ColorApp.mainColor,
                                  color2: Color.fromARGB(255, 22, 78, 181),
                                  lastUpdateDate: "2025-26-05",
                                );
                              }),
                              Gap.h20,
                              Obx(() {
                                final spent = controller.totalSpentByType;

                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Categorycard(
                                  title: 'Travel',
                                  amount: spent['travel'] ?? 0,
                                  color1: Color(0xFFEC4899),
                                  color2: Color.fromARGB(255, 179, 55, 117),
                                  lastUpdateDate: "2025-26-05",
                                );
                              }),

                              Gap.h20,
                              Obx(() {
                                final spent = controller.totalSpentByType;

                                if (controller.isLoading.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Categorycard(
                                  title: 'Item',
                                  amount: spent['item'] ?? 0,
                                  color1: Color(0xFFF59E0B),
                                  color2: Color.fromARGB(255, 185, 123, 14),
                                  lastUpdateDate: "2025-26-05",
                                );
                              }),

                              Gap.h20,
                              // _buildInvestmentWalletCard,
                              // _buildBestOpportunitiesCard(),
                              // SizedBox(height: 20),
                              // _buildLoanRequestCard(),
                              // SizedBox(height: 20),
                              // _buildFundCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // Expanded(child: _buildBorrowingCard()),
                        // SizedBox(width: 20),
                        // Expanded(child: _buildBorrowingCard()),
                        // SizedBox(width: 20),
                        // Expanded(child: _buildBorrowingCard()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
