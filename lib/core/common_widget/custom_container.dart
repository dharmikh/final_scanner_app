import 'package:flutter/material.dart';

class CustomBorderContainer extends StatelessWidget {
  final Color borderColor;
  final VoidCallback? onTap;
  final Widget? child;

  const CustomBorderContainer({
    super.key,
    required this.borderColor,
    this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 83,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(11),
            bottomRight: Radius.circular(11),
          ),
          border: Border(
            left: BorderSide(
              color: borderColor,
              width: 5,
            ),
            top: BorderSide(
              color: borderColor,
              width: 1,
            ),
            right: BorderSide(
              color: borderColor,
              width: 1,
            ),
            bottom: BorderSide(
              color: borderColor,
              width: 1,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
