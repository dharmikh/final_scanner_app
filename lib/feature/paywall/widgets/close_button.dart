import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:final_scanner_app/feature/ratting/view/ratting_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Closebutton extends StatelessWidget {
  final BoxShape shape;
  final BorderRadiusGeometry? borderRadiusGeometry;

  const Closebutton({super.key, required this.shape, this.borderRadiusGeometry});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.off(() => RatingView());
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(shape: shape, color: AppColor.primaryColor, borderRadius: borderRadiusGeometry),
        child: Icon(Icons.close, color: AppColor.light),
      ),
    );
  }
}
