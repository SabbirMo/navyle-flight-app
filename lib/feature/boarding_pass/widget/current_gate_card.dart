import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class CurrentGateCard extends StatelessWidget {
  final String gate;
  final int walkTimeMinutes;

  const CurrentGateCard({
    super.key,
    required this.gate,
    required this.walkTimeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF071224).withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? const Color(0xFF2563EB).withValues(alpha: 0.65)
                  : const Color(0xFF60A5FA).withValues(alpha: 0.80),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0xFF1D4ED8).withValues(alpha: 0.45)
                    : const Color(0xFF3B82F6).withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'CURRENT GATE',
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF1E293B),
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF0B2240)
                          : const Color(0xFFEFF6FF),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF1D4ED8)
                            : const Color(0xFF2563EB),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        ImageAssets.gate,
                        width: 14.w,
                        height: 14.w,
                        colorFilter: ColorFilter.mode(
                          isDark
                              ? const Color(0xFF38BDF8)
                              : AppColors.boardingPassBg,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    gate,
                    style: GoogleFonts.inter(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : AppColors.boardingPassBg,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_walk_rounded,
                    size: 15.sp,
                    color: isDark
                        ? const Color(0xFF38BDF8)
                        : AppColors.boardingPassBg,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${walkTimeMinutes}m walk',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFF38BDF8)
                          : AppColors.boardingPassBg,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
