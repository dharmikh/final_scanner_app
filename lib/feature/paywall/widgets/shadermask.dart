import 'package:flutter/material.dart';

class Shadermask extends StatelessWidget {
  final String image;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const Shadermask({super.key, required this.image, required this.begin, required this.end});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [
              Colors.black12,
              Colors.black12,
              Colors.white30,
              Colors.white38,
              Colors.white60,
              Colors.white70,
              Colors.white70,
              Colors.white70,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
            begin: begin,
            end: end,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Image.asset(image, fit: BoxFit.cover, height: double.infinity, width: double.infinity),
      ),
    );
  }
}
