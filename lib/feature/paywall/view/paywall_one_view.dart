import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/paywall_main_button.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/paywall/view/paywall_two_view.dart';
import 'package:final_scanner_app/feature/paywall/widgets/close_button.dart';
import 'package:final_scanner_app/feature/paywall/widgets/customTPRrow.dart';
import 'package:final_scanner_app/feature/paywall/widgets/shadermask.dart';
import 'package:final_scanner_app/feature/paywall/widgets/subscription_process_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaywallOneView extends StatefulWidget {
  const PaywallOneView({super.key});

  @override
  State<PaywallOneView> createState() => _PaywallOneViewState();
}

class _PaywallOneViewState extends State<PaywallOneView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Shadermask(image: AppImages.paywall1Image, begin: Alignment.topLeft, end: Alignment.bottomRight),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      AppText.manRope24500(text: AppString.upgradeToPremiumText, color: AppColor.primaryColor),
                      Image.asset(AppImages.premiumImage, color: AppColor.primaryColor),
                      const Spacer(),
                      Closebutton(shape: BoxShape.circle),
                    ],
                  ),
                  Column(
                    children: [
                      AppText.manRope33800(text: AppString.unlockText, color: AppColor.primaryColor),
                      AppText.manRope33800(text: AppString.accessText, color: AppColor.primaryColor),
                    ],
                  ),
                  const SubscriptionProcessList(),
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppColor.lightPink),
                      color: AppColor.light,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppText.manRope16(text: AppString.free7Text, color: AppColor.dark),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Divider(indent: 20, endIndent: 20, thickness: 2, color: AppColor.lightPink),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText.manRope24600(text: AppString.month7Text, color: AppColor.primaryColor),
                            AppText.manRope16(text: AppString.monthText, color: AppColor.primaryColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  RatingSubmitButton(
                    borderRadiusGeometry: BorderRadius.circular(6),
                    onTap: () {
                      Get.off(() => PaywallTwoView());
                    },
                    text: AppString.trial7Text,
                  ),
                  const CustomRowWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
