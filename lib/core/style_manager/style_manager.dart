import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleManager {
  static TextStyle sfProBold16(Color color) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontFamily: "SF-Pro",
      color: color,
    );
  }

  static TextStyle sfProBold24(Color color) {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "SF-Pro",
      color: color,
    );
  }

  static TextStyle sfProBold30(Color color) {
    return TextStyle(
      fontSize: 30.sp,
      fontWeight: FontWeight.w700,
      fontFamily: "SF-Pro",
      color: color,
    );
  }

  static TextStyle sfProSemiBold16(Color color) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "SF-Pro",
      color: color,
    );
  }

  static TextStyle sfProSemiBold14(Color color) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "SF-Pro",
      color: color,
    );
  }

  static TextStyle interMedium12(Color color) {
    return GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle interMedium14(Color color) {
    return GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle semiBoldRoboto20(Color color) {
    return GoogleFonts.roboto(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }

  //poppins
  static TextStyle poppinsBold28(Color color) {
    return GoogleFonts.poppins(
      fontSize: 28.sp,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle poppinsBold24(Color color) {
    return GoogleFonts.poppins(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle poppinsBold16(Color color) {
    return GoogleFonts.poppins(
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle interSemiBold14(Color color) {
    return GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle interSemiBold12(Color color) {
    return GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle interMedium13(Color color) {
    return GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  static TextStyle interRegular13(Color color) {
    return GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
