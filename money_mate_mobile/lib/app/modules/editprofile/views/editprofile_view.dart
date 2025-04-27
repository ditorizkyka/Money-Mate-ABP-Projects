import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/widget/buttonApp.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/editprofile_controller.dart';

class EditprofileView extends GetView<EditprofileController> {
  const EditprofileView({super.key});
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController spentController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile ', style: TypographyApp.titleField),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Center(
              child: StreamBuilder(
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
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Gap.h24,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Anda tidak bisa mengganti data lain selain nama panjang anda!",
                    style: TypographyApp.desc.copyWith(color: Colors.grey),
                  ),
                  Gap.h12,
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Ganti nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap.h12,
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          "0",
                          style: TypographyApp.desc.copyWith(
                            color: Colors.grey,
                          ),
                        );
                      }
                      return Text(
                        "Limit pengeluaran anda saat ini adalah ${snapshot.data!['limit']}",
                        style: TypographyApp.desc.copyWith(color: Colors.red),
                      );
                    },
                  ),
                  Gap.h12,
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: spentController,
                    decoration: InputDecoration(
                      labelText: 'Ubah batas pengeluaran',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Gap.h12,
                  Container(
                    width: double.infinity,
                    child: StreamBuilder(
                      stream:
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            snapshot.data!['email'],
                            style: TypographyApp.desc.copyWith(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Gap.h12,
                  ButtonApp(
                    action: "Update",
                    onTap: () {
                      if (nameController.text.isEmpty) {
                        if (spentController.text.isEmpty) {
                          Get.snackbar("Error", "Please enter one field above");
                        } else if (int.parse(spentController.text) < 0) {
                          Get.snackbar(
                            "Error",
                            "Spent limit cannot be negative",
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialog(
                                title: "Update Spent Limit",
                                message:
                                    "Are you sure you want to update your limit?",
                                confirmBtn: "Update",
                                nextEvent: () async {
                                  await controller.updateUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    nameController.text,
                                    int.parse(spentController.text),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      } else {
                        if (spentController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialog(
                                title: "Update Account Name",
                                message:
                                    "Are you sure you want to update your account? if you delete it, you will never get it comeback",
                                confirmBtn: "Update",
                                nextEvent: () async {
                                  await controller.updateUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    nameController.text,
                                    int.parse(spentController.text),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        } else if (int.parse(spentController.text) < 0) {
                          Get.snackbar(
                            "Error",
                            "Spent limit cannot be negative",
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmDialog(
                                title: "Update Account",
                                message:
                                    "Are you sure you want to update your account? if you delete it, you will never get it comeback",
                                confirmBtn: "Update",
                                nextEvent: () async {
                                  await controller.updateUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    nameController.text,
                                    int.parse(spentController.text),
                                  );
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                  Gap.h12,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmDialog(
                            title: "Delete Account",
                            message:
                                " Are you sure you want to delete your account? if you delete it, you will never get it comeback",
                            confirmBtn: "Delete",
                            nextEvent: () async {
                              Navigator.pop(context);
                              await controller.deleteUser();
                              Get.offAllNamed('/signin');
                            },
                          );
                        },
                      );
                    },
                    child: Container(
                      // alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red, // Warna background
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Radius border
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Warna bayangan
                            blurRadius: 5, // Blur bayangan
                            offset: Offset(2, 2), // Arah bayangan
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.white,
                          ),
                          Gap.w12,
                          Text(
                            "Delete Account",
                            style: TypographyApp.mdblack.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
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
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmBtn,
    this.nextEvent,
  });

  final String title;
  final String message;
  final String confirmBtn;
  final VoidCallback? nextEvent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: Colors.white,
      title: Text(title, style: TypographyApp.mdblack),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Back", style: TypographyApp.mdblack),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: ColorApp.mainColor,
          ),
          onPressed: nextEvent,
          child: Text(
            confirmBtn,
            style: TypographyApp.buttonText.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
