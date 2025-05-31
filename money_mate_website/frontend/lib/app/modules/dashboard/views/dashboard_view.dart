import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/modules/activities/controllers/activities_controller.dart';
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
        backgroundColor: ColorApp.mainColor,
        foregroundColor: Colors.white,
        elevation: 6,
        child: Icon(Icons.add, size: 28),
      ),
      body: SafeArea(
        child: Obx(
          () =>
              controller.isLoading.value
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: ColorApp.mainColor),
                        SizedBox(height: 16),
                        Text(
                          'Loading dashboard...',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Header(),
                        SizedBox(height: 20),
                        InvestmentDashboard(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}

class InvestmentDashboard extends StatelessWidget {
  const InvestmentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ActivitiesController activitiesController = Get.put(
      ActivitiesController(),
    );
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
              _buildWelcomeSection(),

              SizedBox(height: 30),

              // Responsive Grid Layout
              if (isWideScreen)
                _buildWideScreenLayout()
              else
                _buildNarrowScreenLayout(),

              SizedBox(height: 20),

              // Category Cards - selalu responsif
              _buildCategorySection(isWideScreen, activitiesController),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildWelcomeSkeleton();
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user.displayName ?? 'User'} 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Member Since ${user.metadata.creationTime?.toLocal().toString().split(' ')[0] ?? 'Unknown'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Guest 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Please login to access all features',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildWelcomeSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 24,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 4),
        Container(
          height: 14,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildWideScreenLayout() {
    return Row(
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout() {
    return Column(
      children: [
        // Portfolio Card
        PortofolioCard(),
        SizedBox(height: 20),

        // Activities Card
        ActivitiesCard(),
        SizedBox(height: 20),

        // Limit Spent Card
        LimitSpentCard(),
        SizedBox(height: 20),

        // Convert Spent Card
        ConvertSpentCard(),
      ],
    );
  }

  Widget _buildCategorySection(
    bool isWideScreen,
    ActivitiesController activitiesController,
  ) {
    if (isWideScreen) {
      // Untuk layar lebar, tampilkan dalam satu baris
      return Row(
        children: [
          Expanded(
            child: Obx(() {
              final spent = activitiesController.totalSpentByType;

              if (activitiesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Categorycard(
                title: 'Education',
                amount: spent['education'] ?? 0,
                color1: ColorApp.mainColor,
                color2: Color.fromARGB(255, 22, 78, 181),
                lastUpdateDate: "2025-26-05",
              );
            }),
          ),
          Gap.w4,
          Expanded(
            child: Obx(() {
              final spent = activitiesController.totalSpentByType;

              if (activitiesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Categorycard(
                title: 'Travel',
                amount: spent['travel'] ?? 0,
                color1: Color(0xFFEC4899),
                color2: Color.fromARGB(255, 179, 55, 117),
                lastUpdateDate: "2025-26-05",
              );
            }),
          ),

          Gap.w4,
          Expanded(
            child: Obx(() {
              final spent = activitiesController.totalSpentByType;

              if (activitiesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Categorycard(
                title: 'Item',
                amount: spent['item'] ?? 0,
                color1: Color(0xFFF59E0B),
                color2: Color.fromARGB(255, 185, 123, 14),
                lastUpdateDate: "2025-26-05",
              );
            }),
          ),
        ],
      );
    } else {
      // Untuk layar sempit, tampilkan dalam kolom
      return Column(
        children: [
          Obx(() {
            final spent = activitiesController.totalSpentByType;

            if (activitiesController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Categorycard(
              title: 'Education',
              amount: spent['education'] ?? 0,
              color1: ColorApp.mainColor,
              color2: Color.fromARGB(255, 22, 78, 181),
              lastUpdateDate: "2025-26-05",
            );
          }),
          Gap.h20,
          Obx(() {
            final spent = activitiesController.totalSpentByType;

            if (activitiesController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Categorycard(
              title: 'Travel',
              amount: spent['travel'] ?? 0,
              color1: Color(0xFFEC4899),
              color2: Color.fromARGB(255, 179, 55, 117),
              lastUpdateDate: "2025-26-05",
            );
          }),

          Gap.h20,
          Obx(() {
            final spent = activitiesController.totalSpentByType;

            if (activitiesController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return Categorycard(
              title: 'Item',
              amount: spent['item'] ?? 0,
              color1: Color(0xFFF59E0B),
              color2: Color.fromARGB(255, 185, 123, 14),
              lastUpdateDate: "2025-26-05",
            );
          }),
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
                _buildLogo(),
                _buildNavigation(),
                const Spacer(),

                _buildUserProfile(),
              ],
            );
          } else {
            // Layout untuk layar sempit
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_buildLogo(), _buildMobileUserAvatar()],
                ),
                SizedBox(height: 10),
                _buildMobileNavigation(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
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
      ],
    );
  }

  Widget _buildNavigation() {
    return Padding(
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
                color:
                    Get.currentRoute == '/dashboard'
                        ? ColorApp.mainColor
                        : Colors.grey,
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
                color:
                    Get.currentRoute == '/activities'
                        ? ColorApp.mainColor
                        : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavigation() {
    return Row(
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
              color:
                  Get.currentRoute == '/dashboard'
                      ? ColorApp.mainColor
                      : Colors.grey,
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
              color:
                  Get.currentRoute == '/activities'
                      ? ColorApp.mainColor
                      : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserProfile() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/profile');
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ColorApp.mainColor.withOpacity(0.1),
            child: Icon(Icons.person, color: ColorApp.mainColor, size: 20),
          ),
          Gap.w4,
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildUserProfileSkeleton();
              }

              if (snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error',
                      style: TypographyApp.headline1.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Please refresh',
                      style: TypographyApp.headline1.copyWith(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }

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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }

              final User user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName ?? 'No Name',
                    style: TypographyApp.headline1.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    user.email ?? 'No Email',
                    style: TypographyApp.headline1.copyWith(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileUserAvatar() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/profile');
      },
      child: CircleAvatar(
        radius: 18,
        backgroundColor: ColorApp.mainColor.withOpacity(0.1),
        child: Icon(Icons.person, color: ColorApp.mainColor, size: 18),
      ),
    );
  }

  Widget _buildUserProfileSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 15,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 2),
        Container(
          height: 13,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
