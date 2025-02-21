import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:flutter/material.dart';

class SubscriptionProcessList extends StatelessWidget {
  const SubscriptionProcessList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
                    child: Image.asset(AppImages.scanIconImage),
                  ),
                ),
                AppText.manRope20(text: AppString.unlimitedScansText, color: AppColor.primaryColor),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 26),
              child: Container(
                //margin: EdgeInsets.all(5),
                height: 36,
                width: 2,
                color: AppColor.primaryColor,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
                    child: Image.asset(AppImages.generateIconImage),
                  ),
                ),
                AppText.manRope20(text: AppString.generateText, color: AppColor.primaryColor),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 26),
              child: Container(
                //  margin: EdgeInsets.all(5),
                height: 36,
                width: 2,
                color: AppColor.primaryColor,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColor.primaryColor),
                    child: Image.asset(AppImages.enjoyIconImage),
                  ),
                ),
                AppText.manRope20(text: AppString.enjoyText, color: AppColor.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
