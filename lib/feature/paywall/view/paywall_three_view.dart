import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/common_widget/paywall_main_button.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:final_scanner_app/feature/paywall/widgets/close_button.dart';
import 'package:final_scanner_app/feature/paywall/widgets/customTPRrow.dart';
import 'package:final_scanner_app/feature/paywall/widgets/offerContainer.dart';
import 'package:final_scanner_app/feature/paywall/widgets/shadermask.dart';
import 'package:final_scanner_app/feature/paywall/widgets/subscription_process_list.dart';
import 'package:final_scanner_app/feature/subscribedScrenn/view/subscribed_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaywallThreeView extends StatefulWidget {
  const PaywallThreeView({super.key});

  @override
  State<PaywallThreeView> createState() => _PaywallThreeViewState();
}

class _PaywallThreeViewState extends State<PaywallThreeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Shadermask(image: AppImages.specialOfferImage, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Closebutton(shape: BoxShape.rectangle, borderRadiusGeometry: BorderRadius.circular(11))],
                ),
                Column(
                  children: [
                    Offercontainer(
                      end: Alignment.centerRight,
                      begin: Alignment.centerLeft,
                      text: AppString.specialText,
                    ),
                    const SizedBox(height: 10),
                    Offercontainer(end: Alignment.centerLeft, begin: Alignment.centerRight, text: AppString.offText),
                  ],
                ),
                const SubscriptionProcessList(),
                AppText.urbanist16(text: AppString.unlimitedText, color: AppColor.primaryColor),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RatingSubmitButton(
                    borderRadiusGeometry: BorderRadius.circular(6),
                    onTap: () {
                      Get.off(() => SubscribedView());
                    },
                    text: AppString.subscribeText,
                  ),
                ),
                Padding(padding: const EdgeInsets.only(bottom: 30), child: const CustomRowWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
