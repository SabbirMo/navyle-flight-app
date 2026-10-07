import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CityWeatherCard extends StatelessWidget {
  const CityWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFFF7F8FA);
    final baseDark = Color(0xff021F42);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 116.h,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.aIPrimaryColor.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          children: [
            Positioned(
              right: -74,
              top: 0,
              bottom: 0,
              width: 220.w,
              child: Image.asset(
                ImageAssets.city,
                fit: BoxFit.cover,
                alignment: Alignment.centerRight,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? baseDark : baseColor,
                      isDark ? baseDark : baseColor,
                      isDark
                          ? baseDark.withValues(alpha: 0.98)
                          : baseColor.withValues(alpha: 0.98),
                      isDark
                          ? baseDark.withValues(alpha: 0.84)
                          : baseColor.withValues(alpha: 0.84),
                      isDark
                          ? baseDark.withValues(alpha: 0.6)
                          : baseColor.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.44, 0.60, 0.70, 0.80],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),

            // 3. Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frankfurt',
                    style: GoogleFonts.inter(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                  const Spacer(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.cloude,
                        width: 36.w,
                        height: 36.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(width: 8.w),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '24°C',
                            style: GoogleFonts.inter(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.black,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Partly cloudy',
                            style: StyleManager.interMedium12(
                              isDark ? Colors.white : const Color(0xff0B0E14),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 14.w),

                      // Vertical Divider
                      Container(
                        height: 44.h,
                        width: 1.2.w,
                        color: const Color(0xFF556980),
                      ),

                      SizedBox(width: 14.w),

                      // Local time and Date Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local time',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xff0B0E14),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '9:41 AM',
                            style: GoogleFonts.inter(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Tue, Apr 23',
                            style: StyleManager.interMedium12(
                              isDark ? Colors.white : const Color(0xff0B0E14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
