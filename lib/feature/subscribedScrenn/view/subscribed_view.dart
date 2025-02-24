import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/paywall_main_button.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/ratting/view/ratting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribedView extends StatefulWidget {
  const SubscribedView({super.key});

  @override
  State<SubscribedView> createState() => _SubscribedViewState();
}

class _SubscribedViewState extends State<SubscribedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [
                    Colors.black12,
                    Colors.black12,
                    Colors.black12,
                    Colors.white10,
                    Colors.white12,
                    Colors.white30,
                    Colors.white38,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.black26, BlendMode.srcATop),
                child: Image.asset(AppImages.specialOfferScreenImage, fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Image.asset(AppImages.celebrationImage, fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.sizeOf(context).height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(AppImages.wowImageText, color: AppColor.light),
                  Image.asset(AppImages.madeYourImageText),
                  AppText.manRope20(text: AppString.congratulationsText, color: AppColor.light),
                  RatingSubmitButton(
                    borderRadiusGeometry: BorderRadius.circular(6),
                    onTap: () {
                      Get.off(() => RatingView());

                    },
                    text: AppString.startedText,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
