import 'package:final_scanner_app/core/common_widget/app_text.dart';
import 'package:final_scanner_app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class Offercontainer extends StatelessWidget {
  final String text;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const Offercontainer({super.key, required this.text, required this.begin, required this.end});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
            Colors.white70,
            Colors.white70,
            Colors.white70,
            Colors.white30,
            Colors.white.withOpacity(0),
          ],
          begin: begin,
          end: end,
        ),
      ),
      child: Center(
        child: Align(alignment: begin, child: AppText.montserrat28(text: text, color: AppColor.primaryColor)),
      ),
    );
  }
}
