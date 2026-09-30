import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/setting/smart_watch/model/smart_watch_state.dart';

class SmartWatchFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String statusText;
  final FeatureStatusType statusType;
  final String description;

  const SmartWatchFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.statusText,
    required this.statusType,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFFFEDD5), width: 1),
            ),
            child: Center(
              child: Icon(icon, color: const Color(0xFF475569), size: 19.sp),
            ),
          ),
          SizedBox(width: 10.w),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Badge Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    _buildStatusBadge(),
                  ],
                ),
                SizedBox(height: 5.h),
                // Description
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.organicBrown,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bg;
    Color border;
    Color contentColor;
    IconData badgeIcon;

    switch (statusType) {
      case FeatureStatusType.unavailable:
        bg = const Color(0xFFFFF7ED);
        border = const Color(0xFFFED7AA);
        contentColor = const Color(0xFFEA580C);
        badgeIcon = Icons.error_outline_rounded;
        break;
      case FeatureStatusType.waiting:
        bg = const Color(0xFFEFF6FF);
        border = const Color(0xFFBFDBFE);
        contentColor = const Color(0xFF2563EB);
        badgeIcon = Icons.access_time_rounded;
        break;
      case FeatureStatusType.available:
        bg = const Color(0xFFF0FDF4);
        border = const Color(0xFFBBF7D0);
        contentColor = AppColors.darkGreen;
        badgeIcon = Icons.check_circle_outline_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 10.5.sp, color: contentColor),
          SizedBox(width: 3.w),
          Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }
}
