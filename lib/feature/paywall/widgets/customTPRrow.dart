import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_string.dart';
import 'package:flutter/material.dart';

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppText.manRope10(text: AppString.serviceText, color: AppColor.greyColor100),
        AppText.manRope10(text: AppString.policyText, color: AppColor.greyColor100),
        AppText.manRope10(text: AppString.restoreText, color: AppColor.greyColor100),
      ],
    );
  }
}
