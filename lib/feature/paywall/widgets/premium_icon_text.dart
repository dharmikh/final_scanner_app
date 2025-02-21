import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:flutter/material.dart';

class PremiumIconText extends StatelessWidget {
  final String image;
  final String text;

  const PremiumIconText({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: AppColor.primaryColor,
            ),
            child: Image.asset(
              image,
              color: AppColor.primaryColor,
            ),
          ),
          AppText.manRope16(
            text: text,
            color: AppColor.primaryColor,
          ),
          Image.asset(
            AppImages.falseIconImage,
          ),
          Image.asset(
            AppImages.trueIconImage,
          ),
        ],
      ),
    );
  }
}
