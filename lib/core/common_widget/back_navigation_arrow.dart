import 'package:final_scanner_app/core/constant/app_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomIconButton extends StatelessWidget {
  final double? iconSize;
  final VoidCallback? onPress;

  const CustomIconButton({
    super.key,
    this.iconSize,
    this.onPress,
    // Default icon size
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Get.back();
      },
      icon: Image.asset(AppImages.backArrow, width: iconSize, height: iconSize),
    );
  }
}
