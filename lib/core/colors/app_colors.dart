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

  static const Gradient splashGradient = LinearGradient(
    colors: [lightWhite, white, white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.45, 1.0],
  );

  // Black Theme
  static const Color blackShadow = Color(0xFF0F172A); //#0F172A
}
