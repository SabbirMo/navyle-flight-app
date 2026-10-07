import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class SquircleIcon extends StatelessWidget {
  final IconData icon;
  const SquircleIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76.w,
      height: 76.w,
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueShadow.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 34.sp),
      ),
    );
  }
}
