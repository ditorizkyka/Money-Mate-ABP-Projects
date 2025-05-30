import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Observable variables
  var userName = 'John Doe'.obs;
  var userEmail = 'john.doe@example.com'.obs;
  var profileImageUrl = 'https://via.placeholder.com/150'.obs;

  @override
  void onInit() {
    super.onInit();
    // Load user data when controller is initialized
    loadUserData();
  }

  // Load user data from storage or API
  void loadUserData() {
    // TODO: Implement loading user data from your backend/storage
    // For now, using dummy data
    userName.value = 'John Doe';
    userEmail.value = 'john.doe@example.com';
    profileImageUrl.value = 'https://via.placeholder.com/150';
  }

  // Update user name
  void updateUserName(String newName) {
    userName.value = newName;
    // TODO: Update name in backend/storage
    _saveUserData();
  }

  // Change profile image
  void changeProfileImage() {
    // TODO: Implement image picker and upload
    Get.snackbar(
      'Info',
      'Fitur ganti foto profil akan segera tersedia',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Change password
  void changePassword() {
    // TODO: Navigate to change password page or show dialog
    Get.snackbar(
      'Info',
      'Fitur ganti password akan segera tersedia',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Manage notifications
  void manageNotifications() {
    // TODO: Navigate to notification settings page
    Get.snackbar(
      'Info',
      'Pengaturan notifikasi akan segera tersedia',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Privacy settings
  void privacySettings() {
    // TODO: Navigate to privacy settings page
    Get.snackbar(
      'Info',
      'Pengaturan privasi akan segera tersedia',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  // Logout function

  Future<void> logout() async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      await FirebaseAuth.instance.signOut();
      // var box = await Hive.openBox('userBox');
      // box.put('isLoggedIn', false);
      // Navigate to login page

      Get.back(); // Close loading dialog
      _clearUserSession();
      Get.offAllNamed('/signin'); // Adjust route name as per your app

      Get.snackbar(
        'Berhasil',
        'Anda telah keluar dari akun',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error saat sign out: $e");
    }
  }

  // Delete account function
  void deleteAccount() {
    Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Menghapus akun...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Simulate delete account process
    Future.delayed(Duration(seconds: 3), () {
      Get.back(); // Close loading dialog

      // TODO: Call API to delete account
      _performAccountDeletion();

      // Navigate to welcome/login page
      Get.offAllNamed('/welcome'); // Adjust route name as per your app

      Get.snackbar(
        'Akun Dihapus',
        'Akun Anda telah berhasil dihapus',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    });
  }

  // Private methods
  void _saveUserData() {
    // TODO: Save user data to local storage or send to backend
    print('Saving user data: ${userName.value}');
  }

  void _clearUserSession() {
    // TODO: Clear tokens, user data from shared preferences or secure storage
    print('Clearing user session');
  }

  void _performAccountDeletion() {
    // TODO: Call your backend API to delete user account
    print('Deleting user account');
  }
}
