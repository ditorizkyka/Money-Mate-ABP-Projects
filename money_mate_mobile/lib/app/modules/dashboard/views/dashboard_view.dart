import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_mate_mobile/app/modules/addcontent/views/addcontent_view.dart';
import 'package:money_mate_mobile/app/modules/detailcontent/views/detailcontent_view.dart';
import 'package:money_mate_mobile/app/modules/home/views/home_view.dart';
import 'package:money_mate_mobile/app/modules/profile/views/profile_view.dart';
import 'package:money_mate_mobile/constant/constant.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );
    // dashboardController.detailCostInit();
    return Scaffold(
      backgroundColor: ColorApp.primaryGrey,
      body: Obx(
        () => IndexedStack(
          index: dashboardController.selectedIndex.value,
          children: const [
            HomeView(),
            DetailcontentView(),
            AddcontentView(),
            ProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent, // Menghilangkan efek splash
          highlightColor: Colors.transparent, // Menghilangkan efek highlight
        ),
        child: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: dashboardController.selectedIndex.value,
            onTap: (index) => dashboardController.changeIndex(index),
            selectedItemColor: ColorApp.mainColor, // Warna saat dipilih
            unselectedItemColor: Colors.white60, // Warna saat tidak dipilih
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            items: [
              _buildNavItem(
                Icons.home_outlined,
                Icons.home,
                "Home",
                0,
                dashboardController,
              ),
              _buildNavItem(
                Icons.query_stats_outlined,
                Icons.query_stats,
                "Detail",
                1,
                dashboardController,
              ),
              _buildNavItem(
                Icons.add_circle_outline,
                Icons.add_circle,
                "Add",
                2,
                dashboardController,
              ),
              _buildNavItem(
                Icons.person_outline,
                Icons.person,
                "Profile",
                3,
                dashboardController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
    DashboardController controller,
  ) {
    return BottomNavigationBarItem(
      icon: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.selectedIndex.value == index
                  ? filledIcon
                  : outlinedIcon,
              size: 30,
              color:
                  controller.selectedIndex.value == index
                      ? ColorApp
                          .mainColor // Warna saat dipilih
                      : Colors.grey, // Warna saat tidak dipilih
            ),
            Gap.h4, // Jarak antara icon & label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,

                color:
                    controller.selectedIndex.value == index
                        ? ColorApp
                            .mainColor // Warna saat dipilih
                        : Colors.grey, // Warna saat tidak dipilih
              ),
            ),
            // Gap.h8
          ],
        ),
      ),
      label: "",
    );
  }
}
