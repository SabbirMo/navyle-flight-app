import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.white,
      pageTransitionsTheme: _pageTransitionsTheme,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      colorScheme: ColorScheme.light(
        surface: AppColors.white,
        primary: AppColors.primaryColor,
      ),
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
      colorScheme: ColorScheme.dark(
        surface: AppColors.blackShadow,
        primary: AppColors.primaryColor,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
    );
  }
}
