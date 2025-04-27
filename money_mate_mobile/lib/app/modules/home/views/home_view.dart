import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());
    List<String> imgList = [
      'assets/images/C1.png',
      'assets/images/C2.png',
      'assets/images/C3.png',
      'assets/images/C4.png',
    ];
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
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
                  width: 40, // Pastikan ukuran proporsional
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Gap.w12,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Back👋",
                  style: GoogleFonts.nunito(color: Colors.grey, fontSize: 12),
                ),
                Gap.h4,
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
                    return Text(
                      snapshot.data!['name'],
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap.h8,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CarouselSlider.builder(
                      itemCount: imgList.length, // Jumlah item di carousel
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          width: double.infinity, // Lebar penuh
                          // margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(imgList[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true, // Menjalankan slide otomatis
                        enlargeCenterPage: true, // Membesarkan item tengah
                        aspectRatio: 16 / 9, // Rasio aspek gambar
                        viewportFraction:
                            1.0, // Ukuran setiap item dalam viewport
                        onPageChanged: (index, reason) {
                          // Anda bisa menambahkan aksi jika halaman berubah
                          // print('Halaman berubah ke: $index');
                        },
                      ),
                    ),
                  ),
                  Gap.h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Report", style: TypographyApp.titleField),
                      // Spacer(),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                true, // Bisa ditutup dengan klik di luar
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width *
                                      0.8, // 80% dari lebar layar
                                  height:
                                      MediaQuery.of(context).size.height *
                                      0.44, // 50% dari tinggi layar
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Exchange Currency",
                                        textAlign: TextAlign.center,
                                        style: TypographyApp.titleField,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        "Ini adalah konten dalam popup. Kamu bisa menambahkan teks, tombol, atau elemen lain sesuai kebutuhan.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Gap.h12,
                                      StreamBuilder(
                                        stream:
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(
                                                  FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid,
                                                )
                                                .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          return Container(
                                            width: SizeApp.customWidth(120),
                                            child: Text(
                                              "Rp.${snapshot.data!['cost']}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Gap.h12,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Obx(
                                              () => DropdownButtonFormField<
                                                String
                                              >(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                value:
                                                    controller
                                                        .selectedExpense
                                                        .value,
                                                items:
                                                    controller.expenses.map((
                                                      String expense,
                                                    ) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value: expense,
                                                        child: Text(expense),
                                                      );
                                                    }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    controller
                                                        .setSelectedExpense(
                                                          newValue,
                                                        );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Gap.w12,
                                          StreamBuilder(
                                            stream:
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(
                                                      FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid,
                                                    )
                                                    .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              return GestureDetector(
                                                onTap:
                                                    () => controller
                                                        .countCurrency(
                                                          snapshot
                                                              .data!['cost'],
                                                        ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: ColorApp.mainColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons
                                                        .change_circle_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),

                                      // Gap.h12,
                                      Gap.h12,
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 30,
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Convert Currency Result",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Gap.h4,
                                            Obx(
                                              () => Text(
                                                controller.result.string,
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                maxLines:
                                                    1, // Maksimum hanya 1 baris
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap.h12,
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Exchange Currency",
                              style: TypographyApp.titleField.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(
                              Icons.navigate_next_sharp,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                        return Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF135ae1),
                              const Color.fromARGB(255, 47, 110, 228),
                              const Color.fromARGB(255, 156, 186, 241),
                            ], // Warna gradasi
                            begin: Alignment.topCenter, // Mulai dari atas
                            end: Alignment.bottomCenter, // Berakhir di bawah
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Total pengeluaran bulan ini",
                              style: TextStyle(color: Colors.white),
                            ),
                            Gap.h8,
                            Text(
                              "Rp.${snapshot.data!['cost']}",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  // Gap.h8,
                ],
              ),
            ),
            // Gap.h4,
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recent Activity Spent",
                    style: TypographyApp.titleField,
                  ),
                  Gap.h12,
                  StreamBuilder(
                    stream:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('activity')
                            .orderBy('cost', descending: true)
                            .limit(3)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        ); // Tampilkan loading dulu
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return SizedBox(
                          height: 200,
                          child: Center(child: Text('Data not found')),
                        ); // Jika tidak ada data
                      }

                      return Column(
                        children:
                            snapshot.data!.docs.map((doc) {
                              return RecentActivityWidget(
                                name: doc['name'],
                                type: doc['type'],
                                date: doc['date'],
                                priority: doc['priority'],
                              );
                            }).toList(),
                      );
                    },
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

class RecentActivityWidget extends StatelessWidget {
  final String name;
  final String type;
  final String date;
  final int priority;
  const RecentActivityWidget({
    required this.name,
    required this.type,
    required this.date,
    required this.priority,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (type == "Pendidikan") {
      icon = Icons.school_outlined;
    } else if (type == "Travel") {
      icon = Icons.airplanemode_active_rounded;
    } else {
      icon = Icons.shopping_cart_outlined;
    }
    return Container(
      width: double.infinity,
      // height: 20,
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(60),
              color: ColorApp.white,
            ),
            child: Icon(icon, color: ColorApp.mainColor, size: 20),
          ),
          Gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TypographyApp.mdblack.copyWith(fontSize: 15)),
                Gap.h4,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date : $date", style: TypographyApp.desc),
                    Gap.w12,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: priority == 1 ? Colors.red : Colors.green,
                      ),
                      child: Text(
                        priority == 1 ? "Urgent" : "Not Urgent",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Gap.h28,
        ],
      ),
    );
  }
}
