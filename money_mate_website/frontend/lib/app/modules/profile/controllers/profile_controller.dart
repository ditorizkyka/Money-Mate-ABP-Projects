import 'dart:developer';
import 'package:dio/dio.dart'; // Tambahkan import ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/data/model/UserAccount.dart';
import 'package:frontend/app/shared/constanta.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Observable variables
  var currentUser =
      UserAccount(
        id: 0,
        firebaseUid: '',
        name: '',
        email: '',
        limit: 0,
        totalSpent: '0',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ).obs; // Observable for user name
  var profileImageUrl = 'https://via.placeholder.com/150'.obs;
  var isLoading = false.obs;
  var name = ''.obs; // Observable for user name input

  @override
  void onInit() {
    super.onInit();

    loadUserData(FirebaseAuth.instance.currentUser?.uid ?? '');
  }

  // Load user data from storage or API
  Future<void> loadUserData(String uid) async {
    try {
      isLoading.value = true;
      final response = await dio.get(
        'https://money-mate-app-main-ss3clf.laravel.cloud/api/user/$uid',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        UserAccount user = UserAccount.fromJson(response.data['data']);
        currentUser.value = user; // Update observable with user data
        // Pemanggilan metode pemisah dan perhitungan
        name.value = user.name; // Set initial name value
        isLoading.value = false;
      } else {
        throw Exception("HTTP ${response.statusCode}: Failed to get activity");
      }
    } on DioException catch (e) {
      log("Dio error: $e");
    } catch (e) {
      log("Get activity error: $e");
      Get.snackbar("Error", "Failed to get User: ${e.toString()}");
    }
  }

  // Update user name

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

  Future<void> setNewName(String newName) async {
    try {
      // Validasi user login
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isEmpty) {
        Get.snackbar(
          "Error",
          "User tidak login",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Validasi input
      if (newName.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Nama tidak boleh kosong!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      // Update Firebase displayName
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        newName.trim(),
      );

      // Update backend
      final response = await dio.put(
        'https://money-mate-app-main-ss3clf.laravel.cloud/api/user/$uid',
        data: {'name': newName.trim(), '_method': 'PUT'},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Update local state
        name.value = newName.trim();

        Get.snackbar(
          "Berhasil",
          "Nama berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Gagal memperbarui nama: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = "Gagal memperbarui nama";

      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Koneksi timeout";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server tidak merespon";
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = "Tidak dapat terhubung ke server";
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final responseData = e.response!.data;

        if (statusCode == 422) {
          errorMessage =
              "Data tidak valid: ${responseData['message'] ?? 'Periksa data Anda'}";
        } else if (statusCode == 500) {
          errorMessage = "Server error";
        } else if (statusCode == 404) {
          errorMessage = "User tidak ditemukan";
        } else {
          errorMessage =
              "Error: ${responseData['message'] ?? 'Terjadi kesalahan'}";
        }
      }

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print("Dio Error: ${e.toString()}");
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Gagal memperbarui profil Firebase";

      if (e.code == 'requires-recent-login') {
        errorMessage = "Silakan login ulang untuk memperbarui profil";
      }

      Get.snackbar(
        "Error Firebase",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print("Firebase Error: ${e.toString()}");
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui nama: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      print("General Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Logout function dengan proper error handling
  Future<void> logout() async {
    try {
      // Show loading
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Close loading dialog
      Get.back();

      // Navigate to signin page
      Get.offAllNamed('/signin');

      Get.snackbar(
        'Berhasil',
        'Anda telah keluar dari akun',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Gagal keluar dari akun: ${e.message}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Firebase Auth Error saat logout: $e");
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error saat logout: $e");
    }
  }

  // Delete account function dengan proper implementation
  Future<void> deleteAccount() async {
    try {
      // Show loading
      final user = FirebaseAuth.instance.currentUser;

      Get.dialog(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator()],
          ),
        ),
        barrierDismissible: false,
      );
      if (user != null) {
        await user.delete(); // <- Ini menghapus akun dari Firebase Auth
        // Delete from backend first
        await _deleteUserFromBackend(user.uid);
      } else {
        Get.back();
        Get.snackbar(
          'Error',
          'User tidak ditemukan',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Navigate to welcome page
      Get.offAllNamed('/signin');

      Get.snackbar(
        'Akun Dihapus',
        'Akun Anda telah berhasil dihapus',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      Get.back(); // Close loading dialog

      String errorMessage = "Gagal menghapus akun";
      if (e.code == 'requires-recent-login') {
        errorMessage = "Silakan login ulang sebelum menghapus akun";
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Gagal menghapus data dari server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Gagal menghapus akun: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error menghapus akun: $e");
    }
  }

  // Method untuk menghapus user dari backend
  Future<void> _deleteUserFromBackend(String uid) async {
    try {
      final response = await dio.delete(
        'https://money-mate-app-main-ss3clf.laravel.cloud/api/user/$uid',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete user from backend');
      }
    } on DioException catch (e) {
      print("Error deleting user from backend: $e");
      // Rethrow untuk ditangkap di method deleteAccount
      rethrow;
    }
  }

  // Private methods
}
