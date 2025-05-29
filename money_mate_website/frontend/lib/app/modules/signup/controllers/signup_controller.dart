import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/shared/constanta.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable loading state (optional)
  final isLoading = false.obs;

  // Signup method
  Future<void> signup({
    required String fullname,
    required String email,
    required String password,
    required int limit,
  }) async {
    isLoading.value = true;
    try {
      // Buat user baru dengan email & password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Set displayName (fullname)
      await userCredential.user?.updateDisplayName(fullname);

      // Step 3: Simpan data ke Laravel backend
      await saveUserToBackend(
        uid: userCredential.user!.uid,
        fullname: fullname,
        email: email,
        limit: limit,
      );

      Get.snackbar("Success", "User berhasil didaftarkan");
      // melakukan penyimpanan data ke laravel backend

      // Arahkan ke halaman lain, misalnya dashboard
      Get.offAllNamed('/dashboard'); // ganti sesuai rute kamu
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";

      if (e.code == 'email-already-in-use') {
        message = "Email sudah terdaftar";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah";
      }

      Get.snackbar("Signup Gagal", message);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk menyimpan data ke Laravel backend
  Future<Map<String, dynamic>?> saveUserToBackend({
    required String uid,
    required String fullname,
    required String email,
    required int limit,
  }) async {
    try {
      final response = await dio.post(
        'http://localhost:8000/api/user', // endpoint Laravel Anda
        data: {
          'firebase_uid': uid,
          'name': fullname,
          'email': email,
          'limit': limit,
          'total_spent': 0,
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
}
