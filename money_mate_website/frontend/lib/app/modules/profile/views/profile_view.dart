import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/dashboard/views/dashboard_view.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      body: SafeArea(
        child: Obx(() {
          // Show loading indicator when isLoading is true
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorApp.mainColor,
                    ),
                  ),
                  Gap.h16,
                  Text(
                    'Memuat profil...',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          // Show main content when not loading
          return SingleChildScrollView(
            child: Column(
              children: [
                Header(),
                Gap.h12,

                // Profile Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorApp.mainColor,
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                Gap.h8,
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.account_circle_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                Gap.h8,
                                Text(
                                  'Anda belum masuk',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        }

                        // User is logged in
                        return Column(
                          children: [
                            // Profile Image
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: ColorApp.mainColor
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.person,
                                    color: ColorApp.mainColor,
                                    size: 50,
                                  ),
                                ),

                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorApp.mainColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        controller.changeProfileImage();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gap.h16,

                            // User Name
                            Obx(
                              () => Text(
                                controller.name.value.isNotEmpty
                                    ? controller.name.value
                                    : 'Nama Anda',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            Gap.h8,

                            // User Email
                            Obx(
                              () => Text(
                                controller.currentUser.value.email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // Menu Options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      // Edit Name
                      _buildMenuTile(
                        icon: Icons.edit,
                        title: 'Ubah Nama',
                        subtitle: 'Ganti nama profil Anda',
                        onTap: () => _showEditNameDialog(context),
                      ),
                      Gap.h12,

                      // Change Password
                      _buildMenuTile(
                        icon: Icons.lock_outline,
                        title: 'Ubah Password',
                        subtitle: 'Ganti password akun Anda',
                        onTap: () => controller.changePassword(),
                      ),
                      Gap.h12,

                      // Notifications
                      _buildMenuTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifikasi',
                        subtitle: 'Atur preferensi notifikasi',
                        onTap: () => controller.manageNotifications(),
                      ),
                      Gap.h12,

                      // Privacy Settings
                      _buildMenuTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privasi',
                        subtitle: 'Kelola pengaturan privasi',
                        onTap: () => controller.privacySettings(),
                      ),
                      Gap.h32,

                      // Logout Button
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () => _showLogoutDialog(context),
                          icon: Icon(Icons.logout, color: Colors.white),
                          label: Text(
                            'Keluar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                controller.isLoading.value
                                    ? Colors.grey
                                    : Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Gap.h12,

                      // Delete Account Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () => _showDeleteAccountDialog(context),
                          icon: Icon(
                            Icons.delete_forever,
                            color:
                                controller.isLoading.value
                                    ? Colors.grey
                                    : Colors.red,
                          ),
                          label: Text(
                            'Hapus Akun',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                  controller.isLoading.value
                                      ? Colors.grey
                                      : Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,

                            side: BorderSide(
                              color:
                                  controller.isLoading.value
                                      ? Colors.grey
                                      : Colors.red,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Gap.h32,
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          onTap: controller.isLoading.value ? null : onTap,
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  controller.isLoading.value
                      ? Colors.grey.withOpacity(0.1)
                      : ColorApp.mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color:
                  controller.isLoading.value ? Colors.grey : ColorApp.mainColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: controller.isLoading.value ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color:
                  controller.isLoading.value
                      ? Colors.grey[400]
                      : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color:
                controller.isLoading.value
                    ? Colors.grey[300]
                    : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Ubah Nama'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              Gap.h8,
              Obx(
                () =>
                    controller.isLoading.value
                        ? LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorApp.mainColor,
                          ),
                        )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () {
                        if (nameController.text.trim().isNotEmpty) {
                          controller.setNewName(nameController.text.trim());
                          Get.back();
                        } else {
                          Get.snackbar(
                            'Error',
                            'Nama tidak boleh kosong',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor:
                    controller.isLoading.value
                        ? Colors.grey
                        : ColorApp.mainColor,
                foregroundColor: Colors.white,
              ),
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Konfirmasi Keluar'),
        content: Text('Apakah Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () {
                        Get.back();
                        controller.logout();
                      },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor:
                    controller.isLoading.value ? Colors.grey : Colors.red,
                foregroundColor: Colors.white,
              ),
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Keluar'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    Get.dialog(
      barrierDismissible: true,
      useSafeArea: true,
      AlertDialog(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'Hapus Akun',
            style: TypographyApp.headline2.copyWith(color: Colors.red),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
            Gap.h16,
            Text(
              'Apakah Anda yakin ingin menghapus akun? Tindakan ini tidak dapat dibatalkan\n dan semua data Anda akan dihapus secara permanen.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.black)),
          ),
          Obx(
            () => ElevatedButton(
              onPressed:
                  controller.isLoading.value
                      ? null
                      : () {
                        Get.back();
                        controller.deleteAccount();
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.isLoading.value ? Colors.grey : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child:
                  controller.isLoading.value
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text('Hapus Akun'),
            ),
          ),
        ],
      ),
    );
  }
}
