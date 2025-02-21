import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class RatingSubmitButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final BorderRadiusGeometry? borderRadiusGeometry;

  const RatingSubmitButton({super.key, required this.text, this.onTap, this.borderRadiusGeometry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(borderRadius: borderRadiusGeometry, color: AppColor.primaryColor),
        alignment: Alignment.center,
        child: AppText.manRope16(text: text, color: AppColor.light),
      ),
    );
  }
}
