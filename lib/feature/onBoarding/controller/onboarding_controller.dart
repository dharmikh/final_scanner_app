import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/paywall/view/paywall_one_view.dart';
import 'package:final_scanner_app/models/onboardingModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<OnboardingModel> onBoardingData = [
    OnboardingModel(
      image: AppImages.onboarding1,
      title: AppString.onboardingOne,
      description: AppString.onboardingOneData,
    ),
    OnboardingModel(
      image: AppImages.onboarding2,
      title: AppString.onboardingTwo,
      description: AppString.onboardingTwoData,
    ),
    OnboardingModel(
      image: AppImages.onboarding3,
      title: AppString.onboardingThree,
      description: AppString.onboardingThreeData,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void skipToPaywall() {
    Get.off(() => PaywallOneView());
  }

  void goToNextPage() {
    if (currentPage.value < onBoardingData.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      skipToPaywall();
    }
  }
}
