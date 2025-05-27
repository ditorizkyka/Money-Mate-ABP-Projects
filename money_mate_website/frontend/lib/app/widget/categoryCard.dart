// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:frontend/constant/constant.dart';

class Categorycard extends StatelessWidget {
  String title;
  int amount;
  String lastUpdateDate;
  Color color1;
  Color color2;

  Categorycard({
    super.key,
    required this.title,
    required this.amount,
    required this.lastUpdateDate,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeApp.customHeight(185),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color1, color2, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(Icons.arrow_outward, size: 18, color: Colors.white70),
            ],
          ),
          SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rp$amount',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                ' 250',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Text(
            'Category Amount',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.white70),
              SizedBox(width: 6),
              Text(
                '2025-09-01',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: 20),

          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.white,
          //       foregroundColor: Color(0xFF6366F1),
          //       elevation: 0,
          //       padding: EdgeInsets.symmetric(vertical: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //     ),
          //     child: Text('Pay Now'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
