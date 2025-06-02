// ==================== CONTROLLER ====================
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:frontend/app/shared/constanta.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Model untuk expense category
class ExpenseCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

// Model untuk priority level
class PriorityLevel {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  PriorityLevel({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}

class AddActivitiesController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Observable variables
  final selectedCategory = Rx<ExpenseCategory?>(null);
  final selectedPriority = Rx<PriorityLevel?>(null);
  final selectedDate = DateTime.now().obs;
  final isLoading = false.obs;

  Future<Map<String, dynamic>?> saveActivitiesToBackend({
    required String uid,
    required String nameActivity,
    required String description,
    required String type,
    required String priority,
    required double spent,
    required String date,
    required int limit,
  }) async {
    try {
      final response = await dio.post(
        'https://money-mate-app-main-ss3clf.laravel.cloud/api/activities', // endpoint Laravel Anda
        data: {
          'firebase_uid': uid,
          'name': nameActivity,
          'description': description,
          'type': type,
          'priority': priority,
          'spent': spent,
          'date': date,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            // Jika menggunakan authentication token
            // 'Authorization': 'Bearer YOUR_TOKEN_HERE',
          },
        ),
      );

      print(response.data); // Debugging response

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to save user to backend');
      }
    } on DioException catch (e) {
      // Handle Dio specific errors
      String errorMessage = "Gagal menyimpan data ke server";

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Koneksi timeout";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server tidak merespon";
      } else if (e.response != null) {
        // Server responded with error
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        if (statusCode == 422) {
          // Validation error
          errorMessage =
              "Data tidak valid: ${responseData['message'] ?? 'Periksa data Anda'}";
        } else if (statusCode == 500) {
          errorMessage = "Server error";
        } else {
          errorMessage =
              "Error: ${responseData['message'] ?? 'Terjadi kesalahan'}";
        }
      }

      Get.snackbar("Error Backend", errorMessage);
      throw Exception(errorMessage);
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan data: ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Data options - Updated according to requirements
  final List<ExpenseCategory> expenseCategories = [
    ExpenseCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      color: Colors.blue,
    ),
    ExpenseCategory(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight,
      color: Colors.indigo,
    ),
    ExpenseCategory(
      id: 'item',
      name: 'Item',
      icon: Icons.shopping_bag,
      color: Colors.purple,
    ),
    ExpenseCategory(
      id: 'other',
      name: 'Other',
      icon: Icons.category,
      color: Colors.grey,
    ),
  ];

  final List<PriorityLevel> priorityLevels = [
    PriorityLevel(
      id: 'urgent',
      name: 'Urgent',
      color: Colors.red,
      icon: Icons.priority_high,
    ),
    PriorityLevel(
      id: 'noturgent',
      name: 'Not Urgent',
      color: Colors.green,
      icon: Icons.low_priority,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default values
    selectedCategory.value = expenseCategories[0];
    selectedPriority.value = priorityLevels[1]; // Not urgent
  }

  @override
  void onClose() {
    titleController.dispose();
    amountController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  // Methods untuk mengubah selection
  void selectCategory(ExpenseCategory category) {
    selectedCategory.value = category;
  }

  void selectPriority(PriorityLevel priority) {
    selectedPriority.value = priority;
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  // Method untuk submit form
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      final formData = {
        'title': titleController.text,
        'category': selectedCategory.value?.id,
        'amount': double.parse(amountController.text),
        'date': selectedDate.value.toIso8601String(),
        'priority': selectedPriority.value?.id,
        'description': descriptionController.text,
        'createdAt': DateTime.now(),
      };

      // Print for debugging
      print('Form submitted: $formData');
      // Simulate API call
      await saveActivitiesToBackend(
        uid: FirebaseAuth.instance.currentUser?.uid ?? 'x',
        nameActivity: titleController.text,
        description: descriptionController.text,
        type: selectedCategory.value?.id ?? 'other',
        priority: selectedPriority.value?.id ?? 'noturgent',
        spent: double.parse(amountController.text),
        date: selectedDate.value.toIso8601String(),
        limit: 0,
      );

      // Show success message
      Get.snackbar(
        'Success!',
        'Activity "${titleController.text}" has been recorded successfully.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        icon: Icon(Icons.check_circle, color: Colors.green[800]),
        duration: Duration(seconds: 3),
      );

      // Clear form
      clearForm();

      // Close page after short delay
      Future.delayed(Duration(seconds: 1), () {
        Get.offAllNamed('/dashboard');
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to record activity: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        icon: Icon(Icons.error, color: Colors.red[800]),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk clear form
  void clearForm() {
    titleController.clear();
    amountController.clear();
    descriptionController.clear();
    selectedCategory.value = expenseCategories[0];
    selectedPriority.value = priorityLevels[1];
    selectedDate.value = DateTime.now();
  }

  // Method untuk format currency
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}

class AddActivities extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddActivitiesController());

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black87),
          onPressed: () => Get.offAllNamed('/dashboard'),
        ),
        title: Text(
          'New Activity',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: controller.clearForm,
            child: Text(
              'Clear',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ColorApp.mainColor,
                      const Color.fromARGB(255, 107, 153, 238),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Record New Expense',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track your spending and manage your finances effectively.',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Form Fields
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
                    // Activity Title
                    _buildLabel('Nama Aktivitas'),
                    _buildTextField(
                      controller: controller.titleController,
                      hintText: 'e.g., Beli Buku Kuliah',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter activity name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Expense Category (4 types only)
                    _buildLabel('Kategori'),
                    Obx(
                      () => _buildCategoryDropdown(
                        value: controller.selectedCategory.value!,
                        items: controller.expenseCategories,
                        onChanged: controller.selectCategory,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Amount
                    _buildLabel('Amount Pengeluaran (Rp)'),
                    _buildTextField(
                      controller: controller.amountController,
                      hintText: '0',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    // Date
                    _buildLabel('Tanggal'),
                    Obx(() => _buildDatePicker(context, controller)),
                    SizedBox(height: 20),

                    // Priority Level (2 types only)
                    _buildLabel('Priority Level'),
                    Obx(
                      () => _buildPriorityDropdown(
                        value: controller.selectedPriority.value!,
                        items: controller.priorityLevels,
                        onChanged: controller.selectPriority,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Description
                    _buildLabel('Deskripsi'),
                    _buildTextField(
                      controller: controller.descriptionController,
                      hintText: 'Add notes about this expense...',
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 32),

                    // Submit Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : controller.submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorApp.mainColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              controller.isLoading.value
                                  ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Saving...'),
                                    ],
                                  )
                                  : Text(
                                    'Record Expense',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Cancel Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Get.offAllNamed('/dashboard'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildCategoryDropdown({
    required ExpenseCategory value,
    required List<ExpenseCategory> items,
    required void Function(ExpenseCategory) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ExpenseCategory>(
          value: value,
          onChanged: (ExpenseCategory? newValue) {
            if (newValue != null) onChanged(newValue);
          },
          items:
              items.map((ExpenseCategory category) {
                return DropdownMenuItem<ExpenseCategory>(
                  value: category,
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          category.icon,
                          color: category.color,
                          size: 18,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        category.name,
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }).toList(),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown({
    required PriorityLevel value,
    required List<PriorityLevel> items,
    required void Function(PriorityLevel) onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PriorityLevel>(
          value: value,
          onChanged: (PriorityLevel? newValue) {
            if (newValue != null) onChanged(newValue);
          },
          items:
              items.map((PriorityLevel priority) {
                return DropdownMenuItem<PriorityLevel>(
                  value: priority,
                  child: Row(
                    children: [
                      Icon(priority.icon, color: priority.color, size: 20),
                      SizedBox(width: 12),
                      Text(
                        priority.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          isExpanded: true,
        ),
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    AddActivitiesController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate.value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: Color(0xFF6366F1)),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          controller.selectDate(picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
            SizedBox(width: 12),
            Text(
              '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Spacer(),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
