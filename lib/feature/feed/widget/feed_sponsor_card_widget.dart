import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

/// Reusable sponsored card widget displayed across feed tabs.
class FeedSponsorCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String? badgeSvgIcon;
  final String buttonText;
  final VoidCallback? onTap;

  const FeedSponsorCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.badgeSvgIcon,
    this.buttonText = AppString.viewOffer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlack : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? AppColors.primaryColor.withValues(alpha: 0.2)
              : const Color(0xFFE5E7EB),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.primaryColor.withValues(alpha: 0.2)
                : AppColors.lightGray.withValues(alpha: 0.6),
            offset: const Offset(0, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Sponsor Image (with optional circular badge)
            SizedBox(
              width: 116.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(image, fit: BoxFit.cover),
                  ),
                  if (badgeSvgIcon != null)
                    Positioned(
                      right: 6.w,
                      bottom: 6.h,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xffB08164),
                          border: Border.all(
                            width: 0.5,
                            color: AppColors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(4.5.w),
                        child: SvgPicture.asset(
                          badgeSvgIcon!,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),

            // Right: Title, description, and action button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.lightGray.withValues(alpha: 0.3)
                          : const Color(0xFFEEF2F6),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_rounded,
                          size: 13.sp,
                          color: isDark
                              ? AppColors.white80
                              : const Color(0xFF64748B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppString.sponsored,
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.white80
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : const Color(0xFF0F172A),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: GoogleFonts.inter(
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.lightGray.withValues(alpha: 0.3)
                            : const Color(0xFFFFF7ED),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFEA580C).withValues(alpha: 0.6),
                          width: .5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFEA580C),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 15.sp,
                            color: const Color(0xFFEA580C),
                          ),
                        ],
                      ),
                    ),
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
