import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class BoardingTimerCard extends StatelessWidget {
  final String formattedTime;
  final String title;
  final String subtitle;

  const BoardingTimerCard({
    super.key,
    required this.formattedTime,
    this.title = 'BOARDING BEGINS IN',
    this.subtitle = "Relax. We've got you covered",
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isDark ? 8.h : 24.h,
          horizontal: 20.w,
        ),
        decoration: isDark
            ? null
            : BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.75),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : AppColors.black.withValues(alpha: 0.7),
                letterSpacing: 3.5,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              formattedTime,
              style: GoogleFonts.inter(
                fontSize: 60.sp,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                letterSpacing: -1.0,
                height: 1.15,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF94A3B8) : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
