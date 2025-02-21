import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/bottomNavigation/controller/bottom_navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavigationView extends StatelessWidget {
  final BottomNavigationController bottomController = Get.put(BottomNavigationController());

  BottomNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(index: bottomController.currentIndex.value, children: bottomController.screens)),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 32),
        child: SizedBox(
          height: 65,
          width: 65,
          child: FloatingActionButton(
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
            shape: const CircleBorder(),
            onPressed: bottomController.showBottomSheet,
            backgroundColor: AppColor.primaryColor,
            child: const Icon(Icons.add, color: AppColor.light, size: 40),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1.0, color: AppColor.greyColor50), // Divider on top
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Theme(
      data: Theme.of(Get.context!).copyWith(
        splashColor: Colors.transparent, // Remove ripple effect
        highlightColor: Colors.transparent, // Remove highlight effect
      ),
      child: BottomNavigationBar(
        elevation: 0.0,
        currentIndex: bottomController.currentIndex.value,
        onTap: bottomController.onTabSelected,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.greyColor100,
        selectedLabelStyle: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.manrope(fontSize: 10, color: AppColor.greyColor100),
        items: [
          _buildNavItem(AppImages.transactions_1, AppImages.transactions_0, 0, AppString.transactionsData),
          _buildNavItem(AppImages.summary_1, AppImages.summary_0, 1, AppString.summaryData),
          const BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.transparent), label: ''),
          _buildNavItem(AppImages.reports_1, AppImages.reports_0, 3, AppString.reportsData),
          _buildNavItem(AppImages.settings_1, AppImages.settings_0, 4, AppString.settingsData),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String active, String inactive, int index, String label) {
    return BottomNavigationBarItem(
      icon: Image.asset(bottomController.currentIndex.value == index ? active : inactive, width: 24, height: 24),
      label: label,
    );
  }
}
