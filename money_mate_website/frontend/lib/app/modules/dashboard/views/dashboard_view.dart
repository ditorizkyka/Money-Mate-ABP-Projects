import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/widget/activitiesCard.dart';
import 'package:frontend/app/widget/addActivities.dart';
import 'package:frontend/app/widget/categoryCard.dart';
import 'package:frontend/app/widget/convertSpentCard.dart';
import 'package:frontend/app/widget/limitSpentCard.dart';
import 'package:frontend/app/widget/portofolioCard.dart';
import 'package:frontend/constant/constant.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivities()),
          );
        },
        backgroundColor: Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 6,
        child: Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [Header(), InvestmentDashboard()]),
        ),
      ),
    );
  }
}

class InvestmentDashboard extends StatelessWidget {
  const InvestmentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Tentukan breakpoint untuk responsive design
          bool isWideScreen = constraints.maxWidth > 800;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, ${user?.displayName} 👋',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Member Since ${user?.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? 'Unknown'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome, Riyad Capital 👋',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Member Since April 20, 2023',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Responsive Grid Layout
              if (isWideScreen)
                // Layout untuk layar lebar (desktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          PortofolioCard(),
                          SizedBox(height: 20),
                          ActivitiesCard(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    // Right Column
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          LimitSpentCard(),
                          SizedBox(height: 20),
                          ConvertSpentCard(),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                )
              else
                // Layout untuk layar sempit (mobile/tablet)
                Column(
                  children: [
                    // Kolom pertama (sebelumnya kiri)
                    PortofolioCard(),
                    SizedBox(height: 20),
                    ActivitiesCard(),
                    SizedBox(height: 20),

                    // Kolom kedua (sebelumnya kanan) - pindah ke bawah
                    LimitSpentCard(),
                    SizedBox(height: 20),
                    ConvertSpentCard(),
                    SizedBox(height: 20),
                  ],
                ),

              // Category Cards - selalu responsif
              _buildCategorySection(isWideScreen),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(bool isWideScreen) {
    if (isWideScreen) {
      // Untuk layar lebar, tampilkan dalam satu baris
      return Row(
        children: [
          Expanded(
            child: Categorycard(
              title: 'Education',
              amount: 1000000,
              color1: ColorApp.mainColor,
              color2: Color.fromARGB(255, 22, 78, 181),
              lastUpdateDate: "2025-26-05",
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Categorycard(
              title: 'Travel',
              amount: 1000000,
              color1: Color(0xFFEC4899),
              color2: Color.fromARGB(255, 179, 55, 117),
              lastUpdateDate: "2025-26-05",
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Categorycard(
              title: 'Item',
              amount: 1000000,
              color1: Color(0xFFF59E0B),
              color2: Color.fromARGB(255, 185, 123, 14),
              lastUpdateDate: "2025-26-05",
            ),
          ),
        ],
      );
    } else {
      // Untuk layar sempit, tampilkan dalam kolom
      return Column(
        children: [
          Categorycard(
            title: 'Education',
            amount: 1000000,
            color1: ColorApp.mainColor,
            color2: Color.fromARGB(255, 22, 78, 181),
            lastUpdateDate: "2025-26-05",
          ),

          SizedBox(height: 20),
          Categorycard(
            title: 'Travel',
            amount: 1000000,
            color1: Color(0xFFEC4899),
            color2: Color.fromARGB(255, 179, 55, 117),
            lastUpdateDate: "2025-26-05",
          ),
          SizedBox(height: 20),
          Categorycard(
            title: 'Item',
            amount: 1000000,
            color1: Color(0xFFF59E0B),
            color2: Color.fromARGB(255, 185, 123, 14),
            lastUpdateDate: "2025-26-05",
          ),
        ],
      );
    }
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          if (isWideScreen) {
            // Layout untuk layar lebar
            return Row(
              children: [
                Row(
                  children: [
                    Image.asset(
                      "assets/icons/newlogo-blue.png",
                      width: 40,
                      color: ColorApp.mainColor,
                    ),
                    Gap.w4,
                    Text(
                      'Money Mate',
                      style: TypographyApp.headline1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 60),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.offAllNamed('/dashboard');
                            },
                            child: Text(
                              'Dashboard',
                              style: TypographyApp.headline1.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Gap.w16,
                          GestureDetector(
                            onTap: () {
                              Get.offAllNamed('/activities');
                            },
                            child: Text(
                              'Activities',
                              style: TypographyApp.headline1.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        // backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                      Gap.w4,
                      StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          // Loading state
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          // Error state
                          if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TypographyApp.headline1.copyWith(
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            );
                          }

                          // User tidak login
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Guest User',
                                  style: TypographyApp.headline1.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Not logged in',
                                  style: TypographyApp.headline1.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          }

                          // User login - tampilkan data user
                          final User user = snapshot.data!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.displayName ??
                                    'No Name', // Fallback jika displayName null
                                style: TypographyApp.headline1.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                user.email ??
                                    'No Email', // Fallback jika email null
                                style: TypographyApp.headline1.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Layout untuk layar sempit
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/newlogo-blue.png",
                          width: 30,
                          color: ColorApp.mainColor,
                        ),
                        Gap.w4,
                        Text(
                          'Money Mate',
                          style: TypographyApp.headline1.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/profile');
                      },
                      child: CircleAvatar(
                        radius: 18,
                        // backgroundImage: AssetImage('assets/images/user.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed('/dashboard');
                      },
                      child: Text(
                        'Dashboard',
                        style: TypographyApp.headline1.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Gap.w16,
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed('/activities');
                      },
                      child: Text(
                        'Activities',
                        style: TypographyApp.headline1.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
