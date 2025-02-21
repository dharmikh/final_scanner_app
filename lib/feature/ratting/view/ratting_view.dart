import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/paywall_main_button.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/bottomNavigation/view/bottom_navigation_view.dart';
import 'package:final_scanner_app/feature/ratting/controller/ratting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingView extends StatelessWidget {
  final RatingController controller = Get.put(RatingController());

  RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppText.manRope24600(text: AppString.rateOurMobileAppText, color: AppColor.primaryColor),
                AppText.manRope16(text: AppString.feedbackText, color: AppColor.greyColor100),
                const SizedBox(height: 50),
                Image.asset(AppImages.rattingPersonImage),
                const SizedBox(height: 50),
                _buildRatingBar(),
                const SizedBox(height: 50),
                RatingSubmitButton(
                  borderRadiusGeometry: BorderRadius.circular(6),
                  onTap: controller.showToast,
                  text: AppString.rateUsText,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Get.offAll(BottomNavigationView());
                  },
                  child: Container(
                    height: 56,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColor.primaryColor),
                    ),
                    alignment: Alignment.center,
                    child: AppText.manRope16(text: AppString.thanksText, color: AppColor.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBar() {
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return GestureDetector(
            onTap: () => controller.updateRating(index + 1.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColor.lightPink),
                ),
                child: Icon(
                  Icons.star,
                  color: index < controller.currentRating.value ? AppColor.primaryColor : AppColor.lightPink1,
                  size: 40.0,
                ),
              ),
            ),
          );
        }),
      );
    });
  }
}
