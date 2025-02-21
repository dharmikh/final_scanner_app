import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/paywall_main_button.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/paywall/view/paywall_three_view.dart' show PaywallThreeView;
import 'package:final_scanner_app/feature/paywall/widgets/close_button.dart';
import 'package:final_scanner_app/feature/paywall/widgets/customTPRrow.dart';
import 'package:final_scanner_app/feature/paywall/widgets/premium_icon_text.dart';
import 'package:final_scanner_app/feature/paywall/widgets/shadermask.dart';
import 'package:flutter/material.dart';

class PaywallTwoView extends StatefulWidget {
  const PaywallTwoView({super.key});

  @override
  State<PaywallTwoView> createState() => _PaywallTwoViewState();
}

class _PaywallTwoViewState extends State<PaywallTwoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Shadermask(image: AppImages.paywall2Image, begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                  AppText.manRope33600(text: AppString.featuresText, color: AppColor.primaryColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppText.manRope16(text: AppString.basicText, color: AppColor.dark),
                            const SizedBox(width: 20),
                            AppText.manRope16(text: AppString.proText, color: AppColor.primaryColor),
                          ],
                        ),
                      ),
                      PremiumIconText(image: AppImages.scanIconImage, text: AppString.unlimitedScansText),
                      PremiumIconText(image: AppImages.generateIconImage, text: AppString.generateText),
                      PremiumIconText(image: AppImages.enjoyIconImage, text: AppString.enjoyText),
                    ],
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(color: AppColor.lightPink),
                              color: Colors.white70,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText.manRope14(text: AppString.monthlyText, color: AppColor.primaryColor),
                                  const Divider(indent: 20, endIndent: 20, thickness: 1, color: AppColor.lightPink),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText.manRope24500(text: AppString.month7Text, color: AppColor.primaryColor),
                                      AppText.manRope16(text: AppString.monthText, color: AppColor.primaryColor),
                                    ],
                                  ),
                                  const Divider(indent: 20, endIndent: 20, thickness: 1, color: AppColor.lightPink),
                                  AppText.manRope10(text: AppString.anytimeText, color: AppColor.primaryColor),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(color: AppColor.primaryColor),
                                  color: Colors.white70,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AppText.manRope14(
                                          text: AppString.annuallyText,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                      const Divider(indent: 20, endIndent: 20, thickness: 1, color: AppColor.lightPink),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          AppText.manRope24500(
                                            text: AppString.yearSubscribedText,
                                            color: AppColor.primaryColor,
                                          ),
                                          AppText.manRope16(text: AppString.yearText, color: AppColor.primaryColor),
                                        ],
                                      ),
                                      const Divider(indent: 20, endIndent: 20, thickness: 1, color: AppColor.lightPink),
                                      AppText.manRope10(text: AppString.anytimeText, color: AppColor.primaryColor),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 11, top: 10),
                                  child: Container(
                                    width: 79,
                                    height: 19,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(11),
                                        bottomLeft: Radius.circular(11),
                                      ),
                                      color: AppColor.primaryColor,
                                    ),
                                    child: Center(
                                      child: AppText.manRope10(text: AppString.save50Text, color: AppColor.light),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  RatingSubmitButton(
                    borderRadiusGeometry: BorderRadius.circular(6),
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaywallThreeView()));
                    },
                    text: AppString.subscribeText,
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
