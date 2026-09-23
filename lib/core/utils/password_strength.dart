import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

enum PasswordStrength {
  none,
  weak,
  medium,
  good,
  strong;

  String get label {
    switch (this) {
      case PasswordStrength.none:
        return "-";
      case PasswordStrength.weak:
        return AppString.weak;
      case PasswordStrength.medium:
        return AppString.medium;
      case PasswordStrength.good:
        return AppString.good;
      case PasswordStrength.strong:
        return AppString.strong;
    }
  }

  Color get color {
    switch (this) {
      case PasswordStrength.none:
        return AppColors.grayColor;
      case PasswordStrength.weak:
        return const Color(0xFFEF4444); // Red
      case PasswordStrength.medium:
        return const Color(0xFFF59E0B); // Amber / Orange
      case PasswordStrength.good:
        return const Color(0xFF10B981); // Emerald / Light Green
      case PasswordStrength.strong:
        return AppColors.green; // Vibrant Green (0xFF22C55E)
    }
  }

  static PasswordStrength calculate(String password) {
    if (password.isEmpty) {
      return PasswordStrength.none;
    }

    if (password.length < 6) {
      return PasswordStrength.weak;
    }

    final bool hasLower = RegExp(r'[a-z]').hasMatch(password);
    final bool hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final bool hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final bool hasSpecial = RegExp(
      r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\/`~]',
    ).hasMatch(password);

    final int types =
        (hasLower ? 1 : 0) +
        (hasUpper ? 1 : 0) +
        (hasDigit ? 1 : 0) +
        (hasSpecial ? 1 : 0);

    // Strong: at least 8 chars with all 4 types, OR at least 12 chars with 3+ types
    if ((password.length >= 8 && types == 4) ||
        (password.length >= 12 && types >= 3)) {
      return PasswordStrength.strong;
    }

    // Good: at least 8 chars with at least 3 types
    if (password.length >= 8 && types >= 3) {
      return PasswordStrength.good;
    }

    // Medium: at least 6 chars with at least 2 types
    if (types >= 2) {
      return PasswordStrength.medium;
    }

    // Otherwise weak
    return PasswordStrength.weak;
  }
}
