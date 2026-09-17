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

  static TextStyle sfProSemiBold16(Color color) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
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
}
