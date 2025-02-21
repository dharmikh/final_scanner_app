import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/Report/view/report_view.dart';
import 'package:final_scanner_app/feature/Setting/view/setting_view.dart';
import 'package:final_scanner_app/feature/Transaction/view/transaction_view.dart';
import 'package:final_scanner_app/feature/summary/view/summery_view.dart';
import 'package:final_scanner_app/feature/transaction_type_dialogue/expense/view/expense_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_image.dart' show AppImages;
import '../../transaction_type_dialogue/camera/view/custom_camera_page.dart' show CustomCameraPage;

class BottomNavigationController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> screens = [TransactionView(), SummeryView(), SizedBox.shrink(), ReportView(), SettingView()];

  void onTabSelected(int index) {
    if (index == 2) return;
    currentIndex.value = index;
  }

  void showBottomSheet() {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          height: 242,
          width: 363,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(45), color: AppColor.light),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 56,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: AppColor.dark),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(AppString.typeText, style: TextStyle(color: AppColor.greyColor100)),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => CustomCameraPage());
                  },
                  child: _buildOption(AppImages.cameraIcon, AppString.receiptText),
                ),
                Divider(color: AppColor.greyColor50),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => ExpensePage(pageStatus: "add"));
                  },
                  child: _buildOption(AppImages.plushIcon, AppString.manuelText),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildOption(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Image.asset(icon),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 20, color: AppColor.dark)),
        ],
      ),
    );
  }
}
