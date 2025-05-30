import 'package:flutter/material.dart';
import 'package:frontend/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';

class LimitSpentCard extends StatelessWidget {
  const LimitSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    DashboardController dashboardController = Get.put(DashboardController());
    return Obx(
      () => Container(
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

            Container(
              decoration: BoxDecoration(
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
                        'Rp${dashboardController.limit.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}, ',
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Your current spent is Rp5.000, 000',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap.h12,
                  Text(
                    'NOTE : ',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    'You can set a limit for your spending to avoid overspending.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Gap.h8,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          dashboardController.isLoading.value
                              ? null
                              : () {
                                showEditLimitSpent(
                                  context,
                                  dashboardController,
                                );
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
                      child:
                          dashboardController.isLoading.value
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Set Limit',
                                style: TextStyle(fontSize: 14),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEditLimitSpent(
    BuildContext context,
    DashboardController controller,
  ) {
    TextEditingController limitSpentController = TextEditingController();
    // Set initial value jika sudah ada limit sebelumnya
    limitSpentController.text = controller.limit.value.toString();

    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      AlertDialog(
        backgroundColor: Colors.white,
        title: SizedBox(
          width: 400,
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
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'New limit (Rp)',
            hintText: 'Enter amount in Rupiah',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixText: 'Rp ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () async {
                        if (limitSpentController.text.isNotEmpty) {
                          // Parse input dan set ke controller
                          try {
                            int newLimit = int.parse(
                              limitSpentController.text.replaceAll(',', ''),
                            );
                            controller.limit.value = newLimit;

                            // Panggil method setLimitSpent
                            await controller.setLimitSpent();

                            Get.back();
                            Get.snackbar(
                              'Successsss',
                              'Limit successfully changed to Rp${newLimit.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Please enter a valid number',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          Get.snackbar(
                            'Error',
                            'Please enter a limit amount',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: ColorApp.mainColor,
                foregroundColor: Colors.white,
              ),
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
