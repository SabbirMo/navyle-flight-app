import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CurrentPlanCard extends StatelessWidget {
  final String planName;
  final String renewalDate;
  final String price;

  const CurrentPlanCard({
    super.key,
    this.planName = "NAVYLA PLUS · Monthly",
    this.renewalDate = "May 14, 2026",
    this.price = "\$9.99",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffF69248), Color(0xffFF9D3E)],
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Crown + Current plan
          Row(
            children: [
              SvgPicture.asset(
                ImageAssets.king,
                width: 18.w,
                height: 16.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Current plan",
                style: StyleManager.interMedium14(AppColors.white),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Plan Name
          Text(
            planName,
            style: TextStyle(
              fontFamily: 'SF-Pro',
              fontSize: 20.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 4.h),

          // Renewal details
          Text(
            "Renews on $renewalDate · $price",
            style: StyleManager.interMedium12(AppColors.white),
          ),
          SizedBox(height: 16.h),

          // Bottom features unlocked row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.37),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 18.sp,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "All premium features unlocked",
                style: StyleManager.interRegular14(const Color(0xffFFFCF3)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
