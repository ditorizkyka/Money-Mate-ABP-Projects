import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frontend/app/shared/constanta.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable loading state
  final isLoading = false.obs;

  // Signup method dengan rollback mechanism
  Future<void> signup({
    required String fullname,
    required String email,
    required String password,
    required int limit,
  }) async {
    isLoading.value = true;
    UserCredential? userCredential;

    try {
      // Step 1: Buat user baru dengan email & password
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Set displayName (fullname)
      await userCredential.user?.updateDisplayName(fullname);

      // Step 3: Simpan data ke Laravel backend
      await saveUserToBackend(
        uid: userCredential.user!.uid,
        fullname: fullname,
        email: email,
        limit: limit,
      );

      // Jika sampai sini, berarti semua berhasil
      Get.snackbar("Success", "User berhasil didaftarkan");
      Get.offAllNamed('/dashboard');
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      String message = "Terjadi kesalahan pada Firebase Auth";

      if (e.code == 'email-already-in-use') {
        message = "Email sudah terdaftar";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah";
      } else if (e.code == 'invalid-email') {
        message = "Format email tidak valid";
      }

      Get.snackbar("Signup Gagal", message);
    } catch (e) {
      // Jika error terjadi setelah Firebase user berhasil dibuat
      // maka kita perlu menghapus user tersebut (rollback)
      if (userCredential?.user != null) {
        await _rollbackFirebaseUser(userCredential!.user!);
      }

      // Tampilkan error message
      Get.snackbar("Error", "Signup gagal: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk rollback (menghapus) user Firebase
  Future<void> _rollbackFirebaseUser(User user) async {
    try {
      print("Melakukan rollback - menghapus user Firebase: ${user.uid}");
      await user.delete();
      print("User Firebase berhasil dihapus");
    } catch (e) {
      print("Gagal menghapus user Firebase: ${e.toString()}");
      // Optional: Anda bisa menambahkan logging atau error handling lainnya
      // Tapi jangan throw error lagi karena sudah dalam kondisi error handling
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
        'http://localhost:8000/api/user',
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
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception(
          'Failed to save user to backend: Status ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMessage = "Gagal menyimpan data ke server";

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
        } else {
          errorMessage =
              "Error: ${responseData['message'] ?? 'Terjadi kesalahan'}";
        }
      }

      // Throw exception dengan pesan yang sudah diformat
      // Ini akan ditangkap oleh catch block di method signup
      throw Exception(errorMessage);
    } catch (e) {
      // Handle general errors
      throw Exception("Gagal menyimpan data: ${e.toString()}");
    }
  }

  // Alternative method: Signup dengan transaction-like approach
  Future<void> signupWithTransaction({
    required String fullname,
    required String email,
    required String password,
    required int limit,
  }) async {
    isLoading.value = true;
    UserCredential? userCredential;
    bool backendSaved = false;

    try {
      // Step 1: Create Firebase user
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 2: Update display name
      await userCredential.user?.updateDisplayName(fullname);

      // Step 3: Save to backend
      await saveUserToBackend(
        uid: userCredential.user!.uid,
        fullname: fullname,
        email: email,
        limit: limit,
      );

      backendSaved = true;

      // Success
      Get.snackbar("Success", "User berhasil didaftarkan");
      Get.offAllNamed('/dashboard');
    } catch (e) {
      // Rollback logic
      if (userCredential?.user != null && !backendSaved) {
        await _rollbackFirebaseUser(userCredential!.user!);
        Get.snackbar(
          "Rollback",
          "Akun Firebase telah dihapus karena gagal menyimpan ke database",
        );
      }

      // Handle specific errors
      if (e is FirebaseAuthException) {
        String message = "Terjadi kesalahan pada Firebase Auth";
        if (e.code == 'email-already-in-use') {
          message = "Email sudah terdaftar";
        } else if (e.code == 'weak-password') {
          message = "Password terlalu lemah";
        }
        Get.snackbar("Signup Gagal", message);
      } else {
        Get.snackbar("Error", "Signup gagal: ${e.toString()}");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
