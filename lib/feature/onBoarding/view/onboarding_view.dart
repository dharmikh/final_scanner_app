import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingController controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.onBoardingData.length,
            itemBuilder: (context, index) {
              return Image.asset(
                controller.onBoardingData[index].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height / 2.6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: AppColor.light, borderRadius: BorderRadius.circular(40)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              controller.onBoardingData.length,
                              (index) => Obx(
                                () => AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                  width: controller.currentPage.value == index ? 20.0 : 20.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    color:
                                        controller.currentPage.value == index
                                            ? AppColor.primaryColor
                                            : AppColor.greyColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: controller.skipToPaywall,
                            style: OutlinedButton.styleFrom(side: BorderSide(color: AppColor.primaryColor, width: 1)),
                            child: AppText.manRope16(text: AppString.skipButton, color: AppColor.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4.4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 350,
                                child: AppText.manRope24600Align(
                                  text: controller.onBoardingData[controller.currentPage.value].title,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 75,
                                width: 350,
                                child: AppText.manRope16Align(
                                  text: controller.onBoardingData[controller.currentPage.value].description,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToNextPage,
                      child: Container(
                        height: 56,
                        width: MediaQuery.of(context).size.height / 2.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColor.primaryColor,
                        ),
                        child: Center(
                          child: AppText.manRope16(text: AppString.continuousButton, color: AppColor.light),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
