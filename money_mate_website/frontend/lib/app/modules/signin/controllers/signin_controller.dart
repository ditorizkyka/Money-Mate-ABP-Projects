import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isLoading = false.obs;

  Future<void> signin({required String email, required String password}) async {
    try {
      isLoading.value = true;

      // Proses login
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigasi ke halaman setelah login berhasil (ubah sesuai kebutuhan)
      Get.snackbar('Login Berhasil', "Login berhasil, selamat datang!");
    } on FirebaseAuthException catch (e) {
      String message = '';
      switch (e.code) {
        case 'user-not-found':
          message = 'Pengguna tidak ditemukan';
          break;
        case 'wrong-password':
          message = 'Password salah';
          break;
        default:
          message = 'Terjadi kesalahan: ${e.message}';
      }

      Get.snackbar('Login Gagal', message);
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
