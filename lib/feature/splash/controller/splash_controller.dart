import 'dart:async';
import 'package:final_scanner_app/feature/onBoarding/view/onboarding_view.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      Get.off(() => OnboardingView());
    });
  }
}
