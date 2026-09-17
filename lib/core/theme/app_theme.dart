import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      pageTransitionsTheme: _pageTransitionsTheme,
    );

    return base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      pageTransitionsTheme: _pageTransitionsTheme,
    );

    return base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
  }
}
