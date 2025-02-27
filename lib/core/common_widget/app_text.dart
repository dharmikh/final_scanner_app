import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  // ManRope Font Styles

  static Text manRope33800({required String text, Color? color, FontWeight fontWeight = FontWeight.w800}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 33, color: color, fontWeight: fontWeight));
  }

  static Text manRope33600({required String text, Color? color, FontWeight fontWeight = FontWeight.w600}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 33, color: color, fontWeight: fontWeight));
  }

  static Text manRope28({required String text, Color? color, FontWeight fontWeight = FontWeight.bold}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 28, color: color, fontWeight: fontWeight));
  }

  static Text manRope24600({required String text, Color? color, FontWeight fontWeight = FontWeight.w600}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 24, color: color, fontWeight: fontWeight));
  }

  static Text manRope24600Align({required String text, Color? color, FontWeight fontWeight = FontWeight.w600}) {
    return Text(
      text,
      style: GoogleFonts.manrope(fontSize: 24, color: color, fontWeight: fontWeight),
      textAlign: TextAlign.center,
    );
  }

  static Text manRope24500({required String text, Color? color, FontWeight fontWeight = FontWeight.w500}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 24, color: color, fontWeight: fontWeight));
  }

  static Text manRope20({required String text, Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 20, color: color, fontWeight: fontWeight));
  }

  static Text manRope18({required String text, Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 18, color: color, fontWeight: fontWeight));
  }

  static Text manRope16Align({required String text, Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      text,
      style: GoogleFonts.manrope(fontSize: 16, color: color, fontWeight: fontWeight),
      textAlign: TextAlign.center,
    );
  }

  static Text manRope16({required String text, Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 16, color: color, fontWeight: fontWeight));
  }

  static Text manRope14({required String text, Color? color, FontWeight fontWeight = FontWeight.w500}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 14, color: color));
  }

  static Text manRope13({required String text, Color? color}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 13, color: color));
  }

  // static Text manRope13OverFlow({required String text, Color color = Colors.black}) {
  //   return Text(
  //     text,
  //     maxLines: 1,
  //     overflow: TextOverflow.ellipsis,
  //     style: GoogleFonts.mangrove(fontSize: 13, color: color),
  //   );
  // }

  static Text manRope10({required String text, Color? color}) {
    return Text(text, style: GoogleFonts.manrope(fontSize: 10, color: color));
  }

  // Urbanist Font Styles
  static Text urbanist20({required String text, Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text, style: GoogleFonts.urbanist(fontSize: 20, color: color, fontWeight: fontWeight));
  }

  static Text urbanist16({required String text, Color? color, FontWeight fontWeight = FontWeight.w400}) {
    return Text(
      text,
      style: GoogleFonts.urbanist(fontSize: 16, color: color, fontWeight: fontWeight),
      textAlign: TextAlign.center,
    );
  }

  static Text urbanist14({required String text, Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text, style: GoogleFonts.urbanist(fontSize: 14, color: color, fontWeight: fontWeight));
  }

  static Text urbanist13({required String text, Color? color, FontWeight fontWeight = FontWeight.normal}) {
    return Text(text, style: GoogleFonts.urbanist(fontSize: 13, color: color, fontWeight: fontWeight));
  }

  // Montserrat Font Styles
  static Text montserrat28({required String text, Color? color, FontWeight fontWeight = FontWeight.w900}) {
    return Text(text, style: GoogleFonts.montserrat(fontSize: 28, color: color, fontWeight: fontWeight));
  }
}
