import 'package:firebase_auth/firebase_auth.dart';
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

      // TODO: Simpan data tambahan seperti `limit` ke Firestore, jika diperlukan

      Get.snackbar("Success", "User berhasil didaftarkan");

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
}
