import 'package:flutter/material.dart';
import 'package:frontend/app/modules/dashboard/views/dashboard_view.dart';
import 'package:frontend/app/widget/activitiesCard.dart';
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
                                              'Wallet & Portfolio Movements',
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
                                      child: ListView.builder(
                                        itemBuilder: (context, index) =>
                                            ActivitiesItem(
                                              title: 'Investment Wallet',
                                              subtitle: 'Received',
                                              amount: '+ ₹ 48 250',
                                              date: '2025-04-28',
                                              bgColor: Colors.red[50]!,
                                              iconColor: Colors.red,
                                              icon: Icons.arrow_downward,
                                            ),
                                        itemCount: 10,
                                      ),
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
                              Categorycard(
                                title: 'Education',
                                amount: 1000000,
                                color1: ColorApp.mainColor,
                                color2: Color.fromARGB(255, 22, 78, 181),
                                lastUpdateDate: "2025-26-05",
                              ),
                              Gap.h20,
                              Categorycard(
                                title: 'Education',
                                amount: 1000000,
                                color1: Color(0xFFEC4899),
                                color2: Color.fromARGB(255, 179, 55, 117),
                                lastUpdateDate: "2025-26-05",
                              ),
                              Gap.h20,
                              Categorycard(
                                title: 'Item',
                                amount: 1000000,
                                color1: Color(0xFFF59E0B),
                                color2: Color.fromARGB(255, 185, 123, 14),
                                lastUpdateDate: "2025-26-05",
                              ),
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
}
