import 'package:flutter/material.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';

class LimitSpentCard extends StatelessWidget {
  const LimitSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeApp.customHeight(270),
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
              Text(
                'Limit Spent',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.arrow_outward, size: 18, color: Colors.grey[600]),
            ],
          ),
          Text(
            'Wallet & Portfolio Movements',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),

          // SizedBox(height: 16),
          Container(
            // padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              // color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap.h16,

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp10.000, ',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '000',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),

                Gap.h16,

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Your current spent is Rp5.000, 000',
                        style: TextStyle(fontSize: 10, color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
                Gap.h12,
                Text(
                  'NOTE : ',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ), // italic
                ),
                Text(
                  'You can set a limit for your spending to avoid overspending.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ), // italic
                ),
                Gap.h8,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showEditLimitSpent(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorApp.mainColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Set Limit', style: TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showEditLimitSpent(BuildContext context) {
    TextEditingController limitSpentController = TextEditingController();
    // nameController.text = controller.userName.value;

    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      AlertDialog(
        backgroundColor: Colors.white,

        title: SizedBox(
          width: 400,
          // height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set your Limit Spent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Gap.h8,
              Text(
                'Wallet & Portfolio Movements',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        content: TextField(
          controller: limitSpentController,
          decoration: InputDecoration(
            labelText: 'Nama Baru',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              if (limitSpentController.text.isNotEmpty) {
                // controller.updateUserName(nameController.text);
                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Nama berhasil diubah',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Simpan'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: ColorApp.mainColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
