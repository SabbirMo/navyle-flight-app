import 'package:flutter/material.dart';

class AppColors {
  static const Color lightWhite = Color(0xccF3EACC); //#FFF3EACC
  static const Color white = Color(0xFFFFFFFF); //#FFFFFF

  static const Gradient splashGradient = LinearGradient(
    colors: [lightWhite, white],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  );
}
