import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class RouteFloatingControls extends StatelessWidget {
  final VoidCallback onLocateTap;
  final VoidCallback onNavigateTap;
  final bool isNavigating;

  const RouteFloatingControls({
    super.key,
    required this.onLocateTap,
    required this.onNavigateTap,
    this.isNavigating = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Compass / Target locate button
        GestureDetector(
          onTap: onLocateTap,
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.textFieldBgColor : AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.my_location_rounded,
                size: 20.sp,
                color: isDark ? AppColors.white : const Color(0xFF475569),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Navigation CTA button
        GestureDetector(
          onTap: onNavigateTap,
          child: AnimatedScale(
            scale: isNavigating ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.45),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.near_me_rounded,
                  size: 28.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
