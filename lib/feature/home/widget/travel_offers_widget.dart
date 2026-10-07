import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            color: isDark ? Color(0xff04294F) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark ? AppColors.lightBlueGray : const Color(0xFFF1F5F9),
              width: 1.0,
            ),
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
                iconColor: AppColors.bedgeColor,
                icon: Icons.cell_tower_rounded,
                categoryText: 'eSIM ',
                subCategoryText: '• Instant',
                subCategoryTextColor: isDark
                    ? Color(0xff8DCAFF)
                    : AppColors.bedgeColor,
                titleText: 'Global eSIM',
                subtitleText: 'Stay connected in 150+ countries.',
                badgeText: 'From \$4.50',
              ),

              Divider(
                height: 1,
                thickness: 0.8,
                color: isDark
                    ? AppColors.lightBlueGray
                    : const Color(0xFFF0F3F7),
                indent: 12.w,
                endIndent: 12.w,
              ),

              // Row 2: Lounge Access
              _OfferItem(
                onTap: onLoungeTap,
                iconColor: isDark
                    ? AppColors.primaryColor
                    : AppColors.bedgeGreen,
                icon: Icons.chair_rounded,
                categoryText: 'lounge ',
                subCategoryText: '• T1 & T2',
                subCategoryTextColor: isDark
                    ? AppColors.primaryColor
                    : AppColors.bedgeGreen,
                titleText: 'Lounge Access',
                subtitleText: 'Complimentary artisan coffee, hot showers.',
                badgeText: 'Partner Perk',
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
  final Color iconColor;
  final IconData icon;
  final String categoryText;
  final String subCategoryText;
  final String titleText;
  final String subtitleText;
  final String badgeText;
  final Color subCategoryTextColor;

  const _OfferItem({
    required this.onTap,
    required this.iconColor,
    required this.icon,
    required this.categoryText,
    required this.titleText,
    required this.subtitleText,
    required this.badgeText,
    required this.subCategoryText,
    required this.subCategoryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                color: AppColors.white,
                border: isDark
                    ? null
                    : Border.all(color: AppColors.primaryColor, width: 1.6),
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
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: categoryText,
                          style: GoogleFonts.inter(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w800,
                            color: subCategoryTextColor,
                          ),
                        ),
                        TextSpan(
                          text: subCategoryText,
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? AppColors.grayD3D3D3
                                : AppColors.organicBrown,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    titleText,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : const Color(0xFF1E293B),
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
                      color: isDark
                          ? AppColors.grayD3D3D3
                          : AppColors.lightGray,
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
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
