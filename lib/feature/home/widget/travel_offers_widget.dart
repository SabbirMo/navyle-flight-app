import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/widgets/title_row_click.dart';

/// Travel offers section displaying curated deals (eSIM, Lounge access)
/// shown when the user does not have an active journey / boarding pass.
class TravelOffersWidget extends StatelessWidget {
  final VoidCallback? onSeeAllTap;
  final VoidCallback? onEsimTap;
  final VoidCallback? onLoungeTap;

  const TravelOffersWidget({
    super.key,
    this.onSeeAllTap,
    this.onEsimTap,
    this.onLoungeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleRowClick(
          title: 'Travel Offers',
          subTitle: 'See all',
          isEnable: true,
          onTap: onSeeAllTap,
        ),
        SizedBox(height: 8.h),

        // Offers Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Row 1: Global eSIM
              _OfferItem(
                onTap: onEsimTap,
                iconBackgroundColor: const Color(0xFFFFEDD5),
                iconColor: const Color(0xFFEA580C),
                icon: Icons.cell_tower_rounded,
                categoryText: 'eSIM • Instant',
                titleText: 'Global eSIM',
                subtitleText: 'Stay connected in 150+ countries.',
                badgeText: 'From \$4.50',
                badgeBackgroundColor: const Color(0xFFFFF7ED),
                badgeBorderColor: const Color(0xFFFFEDD5),
                badgeTextColor: const Color(0xFFC2410C),
              ),

              Divider(
                height: 1,
                thickness: 0.8,
                color: const Color(0xFFF1F5F9),
                indent: 12.w,
                endIndent: 12.w,
              ),

              // Row 2: Lounge Access
              _OfferItem(
                onTap: onLoungeTap,
                iconBackgroundColor: const Color(0xFFDBEAFE),
                iconColor: const Color(0xFF2563EB),
                icon: Icons.chair_rounded,
                categoryText: 'lounge • T1 & T2',
                titleText: 'Lounge Access',
                subtitleText: 'Complimentary artisan coffee, hot showers.',
                badgeText: 'Partner Perk',
                badgeBackgroundColor: const Color(0xFFEEF2FF),
                badgeBorderColor: const Color(0xFFC7D2FE),
                badgeTextColor: const Color(0xFF4338CA),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OfferItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Color iconBackgroundColor;
  final Color iconColor;
  final IconData icon;
  final String categoryText;
  final String titleText;
  final String subtitleText;
  final String badgeText;
  final Color badgeBackgroundColor;
  final Color badgeBorderColor;
  final Color badgeTextColor;

  const _OfferItem({
    required this.onTap,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.icon,
    required this.categoryText,
    required this.titleText,
    required this.subtitleText,
    required this.badgeText,
    required this.badgeBackgroundColor,
    required this.badgeBorderColor,
    required this.badgeTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
        child: Row(
          children: [
            // Left circular icon
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 18.sp),
              ),
            ),
            SizedBox(width: 10.w),

            // Middle text column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryText,
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    titleText,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitleText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6.w),

            // Trailing badge and chevron
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBackgroundColor,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: badgeBorderColor, width: 0.8),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: badgeTextColor,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16.sp,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
