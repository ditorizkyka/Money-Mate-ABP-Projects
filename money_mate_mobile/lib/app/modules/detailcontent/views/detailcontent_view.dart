import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/modules/home/views/home_view.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/detailcontent_controller.dart';

class DetailcontentView extends GetView<DetailcontentController> {
  const DetailcontentView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DetailcontentController());
    controller.fetchActivities();
    return Scaffold(
      backgroundColor: ColorApp.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Detail Activity', style: TypographyApp.titleField),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Lacak Pengeluaran anda!", style: TypographyApp.headline1),
              Gap.h8,
              Text(
                "Statistik data dibawah dan beberapa detail pengeluaran anda dapat membantu anda menentukan prioritas pengeluaran anda",
                style: TypographyApp.desc,
              ),
              Gap.h24,
              Container(
                padding: EdgeInsets.all(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Spent Overview",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "Rp.${snapshot.data!['cost']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1, // Maksimum hanya 1 baris
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(width: 8),

                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Investment
                        StreamBuilder(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('detailCost')
                                  .doc('fixedDocument')
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return Column(
                              children: [
                                _buildCategory(
                                  "Barang",
                                  snapshot.data!['barang'] / 10576,
                                  Colors.blue,
                                  "\$${snapshot.data!['barang']}",
                                ),
                                SizedBox(height: 8),

                                // Entertainment
                                _buildCategory(
                                  "Pendidikan",
                                  snapshot.data!['pendidikan'] / 10576,
                                  Colors.teal,
                                  "\$${snapshot.data!['pendidikan']}",
                                ),
                                SizedBox(height: 8),

                                // Food & Beverages
                                _buildCategory(
                                  "Travel",
                                  snapshot.data!['travel'] / 10576,
                                  Colors.green,
                                  "\$${snapshot.data!['travel']}",
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              Gap.h20,
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Recent Full Activity",
                  style: TypographyApp.mdblack,
                ),
              ),
              Gap.h12,
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('activity')
                        .orderBy('cost', descending: true)
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
      ),
    );
  }

  Widget _buildCategory(
    String title,
    double percentage,
    Color color,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.circle, color: color, size: 10),
                SizedBox(width: 6),
                Text(title, style: TextStyle(fontSize: 14)),
              ],
            ),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1, // Maksimum hanya 1 baris
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }
}
