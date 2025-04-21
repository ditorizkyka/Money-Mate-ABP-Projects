import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:money_mate_mobile/app/services/authServices.dart';
import 'package:money_mate_mobile/app/widget/dialog.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());
    controller.getData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile', style: TypographyApp.titleField),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Gap.h24,
                Center(
                  child: Container(
                    // padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Warna lebih soft
                      shape: BoxShape.circle, // Agar otomatis menjadi lingkaran
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        100,
                      ), // Untuk menghindari sudut kasar
                      child: Image.asset(
                        'assets/images/cat.png',
                        width: 130, // Pastikan ukuran proporsional
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Gap.h20,
                StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Column(
                      children: [
                        Text(
                          snapshot.data!['name'],
                          style: TypographyApp.mdblack.copyWith(fontSize: 25),
                        ),
                        Gap.h4,
                        Text(
                          snapshot.data!['email'],
                          style: TypographyApp.mdblack.copyWith(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                //Menu
                Gap.h24,
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/editprofile');
                      },
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text(
                          "Edit Profile",
                          style: TypographyApp.mdblack,
                        ),
                        trailing: Icon(Icons.navigate_next_outlined),
                      ),
                    ),
                    Gap.h8,
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              shadowColor: Colors.white,
                              title: Text(
                                "Logout",
                                style: TypographyApp.mdblack,
                              ),
                              content: Text("Are you sure want to logout?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Back",
                                    style: TypographyApp.mdblack,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: ColorApp.mainColor,
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await Authservices().signOut();
                                  },
                                  child: Text(
                                    "Confirm",
                                    style: TypographyApp.buttonText.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Log-Out", style: TypographyApp.mdblack),
                        trailing: Icon(Icons.navigate_next_outlined),
                      ),
                    ),
                    Gap.h20,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
