import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class ForgotPasswordIllustration extends StatelessWidget {
  const ForgotPasswordIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: 115.w,
      height: 105.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Blue Question Mark Box (behind top-right)
          Positioned(
            top: 18.h,
            right: -4.w,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(11.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '?',
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),

          // Main White Card with Key (foreground)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 78.w,
              height: 78.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.blackShadow : Colors.white,
                borderRadius: BorderRadius.circular(22.r),
                border: isDark ? Border.all(color: AppColors.blue2563EB) : null,
                boxShadow: [
                  // Warm orange glow below card
                  BoxShadow(
                    color: isDark
                        ? AppColors.aIPrimaryColor
                        : AppColors.primaryColor.withValues(alpha: 0.42),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 10),
                  ),
                  // Subtle top ambient shadow
                  BoxShadow(
                    color: AppColors.blackShadow.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Transform.flip(
                  flipY: true,
                  child: Transform.rotate(
                    angle: 135 * math.pi / 180,
                    child: Icon(
                      Icons.vpn_key_rounded,
                      size: 34.sp,
                      color: isDark ? AppColors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
