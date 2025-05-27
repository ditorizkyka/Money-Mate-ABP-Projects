import 'package:flutter/material.dart';
import 'package:frontend/app/widget/activitiesItem.dart';
import 'package:frontend/constant/constant.dart';

class ActivitiesCard extends StatelessWidget {
  const ActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.arrow_outward, size: 20, color: Colors.grey[600]),
            ],
          ),
          SizedBox(height: 15),
          ActivitiesItem(
            title: 'Investment Wallet',
            subtitle: 'Received',
            amount: '+ ₹ 48 250',
            date: '2025-04-28',
            bgColor: Colors.red[50]!,
            iconColor: Colors.red,
            icon: Icons.arrow_downward,
          ),

          ActivitiesItem(
            title: 'Investment Wallet',
            subtitle: 'Received',
            amount: '+ ₹ 48 250',
            date: '2025-04-28',
            bgColor: Colors.green[50]!,
            iconColor: Colors.green,
            icon: Icons.arrow_downward,
          ),

          ActivitiesItem(
            title: 'Investment Wallet',
            subtitle: 'Received',
            amount: '+ ₹ 48 250',
            date: '2025-04-28',
            bgColor: Colors.green[50]!,
            iconColor: Colors.green,
            icon: Icons.arrow_downward,
          ),
          ActivitiesItem(
            title: 'Investment Wallet',
            subtitle: 'Received',
            amount: '+ ₹ 48 250',
            date: '2025-04-28',
            bgColor: Colors.green[50]!,
            iconColor: Colors.green,
            icon: Icons.arrow_downward,
          ),
        ],
      ),
    );
  }
}
