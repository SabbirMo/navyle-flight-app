import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class AppTheme {
  static const PageTransitionsTheme _pageTransitionsTheme =
      PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );

  /// Centralized InputDecorationTheme for Light & Dark mode
  static InputDecorationTheme _inputDecorationTheme({required bool isDark}) {
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : const Color(0xFFE5E7EB);
    final fillColor = isDark ? const Color(0xFF1E293B) : AppColors.white;
    final hintColor = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0xFF9CA3AF);
    final iconColor = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF9CA3AF);

    return InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 12.h,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: hintColor,
      ),
      prefixIconColor: iconColor,
      suffixIconColor: iconColor,
      prefixIconConstraints: BoxConstraints(
        minWidth: 38.w,
        minHeight: 18.w,
      ),
      suffixIconConstraints: BoxConstraints(
        minWidth: 38.w,
        minHeight: 18.w,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: borderColor, width: 1.1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: borderColor, width: 1.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(
          color: AppColors.primaryColor,
          width: 1.2,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      pageTransitionsTheme: _pageTransitionsTheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: const ColorScheme.light(
        surface: AppColors.white,
        primary: AppColors.primaryColor,
      ),
      inputDecorationTheme: _inputDecorationTheme(isDark: false),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.blackShadow,
      pageTransitionsTheme: _pageTransitionsTheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.blackShadow,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.blackShadow,
        primary: AppColors.primaryColor,
      ),
      inputDecorationTheme: _inputDecorationTheme(isDark: true),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
    );
  }

  /// Helper method to create InputDecoration for auth text fields
  static InputDecoration authInputDecoration({
    required BuildContext context,
    required String hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF9CA3AF);

    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(left: 14.w, right: 8.w),
              child: Icon(
                prefixIcon,
                size: 18.sp,
                color: iconColor,
              ),
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: suffixIcon,
            )
          : null,
    );
  }
}
