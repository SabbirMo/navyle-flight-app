import 'package:flutter/material.dart';

class AppColors {
  static const Color lightWhite = Color(0xFFFFF3EA); //#FFF3EA
  static const Color white = Color(0xFFFFFFFF); //#FFFFFF

  static const Color primaryColor = Color(0xFFFF9D3E); //#FF9D3E
  static const Color lightBgColor = Color(0xFFFFF9F0); //#FFF9F0
  static const Color unSelectColor = Color(0xFFE3E2E0); //#E3E2E0
  static const Color grayColor = Color(0xFF8A817A); //#8A817A
  static const Color black = Color(0xFF1A1A1A); //#1A1A1A
  static const Color rotateCont = Color(0xFFF0E1C7); //#F0E1C7
  static const Color green = Color(0xFF22C55E); //#22C55E
  static const Color brown = Color(0xFF795E44); //#795E44
  static const Color shadowColor = Color(0xFF48626B); //#48626B
  static const Color blueShadow = Color(0xFF3B82F6); //#3B82F6
  static const Color blueColor = Color(0xFF2664EB); //#2664EB
  static const Color lightGray = Color(0xFF94A3B8); //#94A3B8

  //d8956533
  static const Color switchColor = Color(0xD8956533); //#D8956533
  static const Color darkGrayColor = Color(0xFF475569); //#475569

  static const Gradient splashGradient = LinearGradient(
    colors: [lightWhite, white, white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.45, 1.0],
  );

  // Black Theme
  static const Color blackShadow = Color(0xFF0F172A); //#0F172A

  // Aliases & Error Colors
  static const Color buttonGradientStart = primaryColor;
  static const Color textDark = black;
  static const Color errorRed = Color(0xFFEF4444);

  //home page
  static const Color homeAir = Color(0xff01215C); //#01215C
  static const Color homeAir60 = Color(0x9901215C); //#01215C (60%)
  static const Color homeAir0 = Color(0x0001215C); //#01215C (0%)
  static const Color dotColor = Color(0xffBEF23C); //#BEF23C
  static const Color darkBlue0 = Color(0xff0A4F8B); //#0A4F8B
  static const Color darkBlue = Color(0xff014871); //#014871
  static const Color grayD3D3D3 = Color(0xffD3D3D3); //#D3D3D3

  // Bottom gradient (transparent above runway -> solid homeAir behind terminal info)
  static const Gradient homeAirBottomGradient = LinearGradient(
    colors: [homeAir0, homeAir0, homeAir60, homeAir],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.46, 0.65, 0.82],
  );

  // Left gradient (solid homeAir on left -> transparent before airplane)
  static const Gradient homeAirLeftGradient = LinearGradient(
    colors: [homeAir, homeAir, homeAir60, homeAir0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [0.0, 0.28, 0.42, 0.54],
  );

  //bedge gradient
  static const Gradient bedgeGradient = LinearGradient(
    colors: [darkBlue0, darkBlue, darkBlue0, darkBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.32, 0.48, 0.67],
  );

  static const Gradient homeAirGradient = homeAirBottomGradient;
}
