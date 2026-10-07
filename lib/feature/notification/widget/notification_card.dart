import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/notification/model/notification_item.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isHighlighted = item.isHighlighted;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? (isHighlighted ? AppColors.textFieldBgColor : AppColors.darkBlack)
            : (isHighlighted ? const Color(0xFFFFF9F3) : Colors.white),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: isDark
              ? (isHighlighted
                    ? AppColors.primaryColor.withValues(alpha: 0.45)
                    : AppColors.lightBlueGray.withValues(alpha: 0.3))
              : (isHighlighted
                    ? const Color(0xFFFFEAD5)
                    : const Color(0xFFF1F5F9)),
          width: 1.2,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: isDark
                      ? AppColors.primaryColor.withValues(alpha: 0.12)
                      : const Color(0xFFFF942B).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Icon
                _buildIconContainer(context),
                SizedBox(width: 14.w),

                // Right Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Unread indicator row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: StyleManager.interMedium12(
                                isDark
                                    ? AppColors.white
                                    : AppColors.blackShadow,
                              ).copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          if (item.isUnread)
                            Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(left: 8.w),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF8533),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 5.h),

                      // Description / Message
                      Text.rich(
                        TextSpan(
                          children: item.messageSpans.map((span) {
                            return TextSpan(
                              text: span.text,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: span.isBold
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color:
                                    span.color ??
                                    (span.isBold
                                        ? isDark
                                              ? AppColors.primaryColor
                                              : const Color(0xFF1E293B)
                                        : isDark
                                        ? AppColors.lightGray
                                        : const Color(0xFF475569)),
                                height: 1.35,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Timestamp
                      Text(
                        item.timeAgo.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.lightBlueGray
                              : AppColors.lightGray,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (item.type) {
      case NotificationType.gateChange:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFF8533),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF8533).withValues(alpha: 0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              ImageAssets.gate,
              width: 22.w,
              height: 20.w,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        );

      case NotificationType.postVerified:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.green.withValues(alpha: 0.16)
                : const Color(0xFFE8F9EE),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: const BoxDecoration(
                color: Color(0xFF22C55E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 15.sp,
              ),
            ),
          ),
        );

      case NotificationType.securityWarning:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: isDark ? Color(0x1AEFF6FF) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: _buildExclamationCircle(const Color(0xFF3B82F6)),
          ),
        );

      case NotificationType.securityInfo:
        return Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.white.withValues(alpha: 0.1)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: _buildExclamationCircle(
              isDark ? AppColors.lightBlueGray : const Color(0xFF94A3B8),
            ),
          ),
        );
    }
  }

  Widget _buildExclamationCircle(Color color) {
    return Container(
      width: 23.w,
      height: 23.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.8),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            '!',
            style: GoogleFonts.inter(
              color: color,
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
