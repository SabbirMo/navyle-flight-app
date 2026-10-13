import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class BoardingStatusCard extends StatelessWidget {
  final String status;
  final String subtitle;

  const BoardingStatusCard({
    super.key,
    required this.status,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF141116).withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFEA580C).withValues(alpha: 0.45)
                  : const Color(0xFFFDBA74).withValues(alpha: 0.80),
              width: 1.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? const Color(0xFFEA580C).withValues(alpha: 0.35)
                    : const Color(0xFFF97316).withValues(alpha: 0.20),
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
                'BOARDING STATUS',
                style: GoogleFonts.inter(
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.black,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? const Color(0xFF2E1C12)
                          : const Color(0xFFFFF7ED),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFFEA580C)
                            : const Color(0xFFFB923C),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        ImageAssets.flight,
                        width: 13.w,
                        height: 13.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFB923C),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFF94A3B8) : AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
