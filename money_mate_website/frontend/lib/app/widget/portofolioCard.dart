import 'package:flutter/material.dart';
import 'package:frontend/constant/constant.dart';

class PortofolioCard extends StatelessWidget {
  const PortofolioCard({super.key});

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Rp8000',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                ' 900',
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
            child: Row(
              children: [
                Expanded(
                  flex: 35,
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
                Expanded(flex: 28, child: Container(color: Color(0xFFEC4899))),
                Expanded(flex: 22, child: Container(color: Color(0xFF06B6D4))),
                Expanded(
                  flex: 15,
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
            ),
          ),
          SizedBox(height: 16),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryItem('Rp3000,000', 'Education', ColorApp.mainColor),
              _buildCategoryItem('Rp4000,000', 'Travel', Color(0xFFEC4899)),
              _buildCategoryItem('Rp500,000', 'Item', Color(0xFFF59E0B)),
              _buildCategoryItem('Rp600,000', 'Other', Color(0xFF06B6D4)),
            ],
          ),
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
