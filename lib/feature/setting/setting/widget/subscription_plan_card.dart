import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class SubscriptionPlanCard extends StatelessWidget {
  final VoidCallback? onManagePlanTap;

  const SubscriptionPlanCard({super.key, this.onManagePlanTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.subscribeBg, AppColors.subscribeBg],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.subscribeBg.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Crown + NAVYLA PLUS & ACTIVE badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(ImageAssets.king, width: 24.w, height: 20.h),
                  SizedBox(width: 8.w),
                  Text(
                    "NAVYLA PLUS",
                    style: StyleManager.interBold16(
                      AppColors.white,
                    ).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  "ACTIVE",
                  style: StyleManager.interBold10(
                    AppColors.white,
                  ).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Main Plan Title
          Text(
            "YEARLY PREMIUM",
            style: StyleManager.interBold16(AppColors.white).copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: 18.h),

          // Bottom Row: Next Renewal and Manage Plan Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEXT RENEWAL",
                    style: StyleManager.interBold10(
                      AppColors.subscribeHighlightBg,
                    ).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "24 Oct 2026",
                    style: StyleManager.interBold16(AppColors.white).copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onManagePlanTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    "MANAGE PLAN",
                    style: StyleManager.interBold10(
                      AppColors.feedOrange,
                    ).copyWith(fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
