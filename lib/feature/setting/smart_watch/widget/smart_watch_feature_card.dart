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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackShadow : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.lightGray.withValues(alpha: 0.6)
              : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
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
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : const Color(0xFFFFF9F3),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.transparent : const Color(0xFFFFEDD5),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                color: isDark ? Colors.white : const Color(0xFF475569),
                size: 19.sp,
              ),
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
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    _buildStatusBadge(context: context),
                  ],
                ),
                SizedBox(height: 5.h),
                // Description
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Color(0xffA6A6A6) : AppColors.organicBrown,
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

  Widget _buildStatusBadge({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color bg;
    Color border;
    Color contentColor;
    IconData badgeIcon;

    switch (statusType) {
      case FeatureStatusType.unavailable:
        bg = isDark
            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
            : const Color(0xFFFFF7ED);
        border = isDark ? Colors.transparent : const Color(0xFFFED7AA);
        contentColor = isDark
            ? const Color(0xffCF731E)
            : const Color(0xFFEA580C);
        badgeIcon = Icons.error_outline_rounded;
        break;
      case FeatureStatusType.waiting:
        bg = isDark
            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
            : const Color(0xFFEFF6FF);
        border = isDark ? Colors.transparent : const Color(0xFFBFDBFE);
        contentColor = const Color(0xFF2563EB);
        badgeIcon = Icons.access_time_rounded;
        break;
      case FeatureStatusType.available:
        bg = isDark
            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
            : const Color(0xFFF0FDF4);
        border = isDark ? Colors.transparent : const Color(0xFFBBF7D0);
        contentColor = isDark ? Color(0xff059669) : AppColors.darkGreen;
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
