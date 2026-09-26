import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class FeedHeaderWidget extends StatelessWidget {
  final VoidCallback onAddPostTap;

  const FeedHeaderWidget({super.key, required this.onAddPostTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // NAVYLA FEED Brand Header
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                child: Image.asset("assets/images/navyla.png"),
              ),
              SizedBox(width: 8.w),
              Text(
                'FEED',
                style: StyleManager.sfProBold16(
                  AppColors.feedColor,
                ).copyWith(fontSize: 18.sp),
              ),
            ],
          ),

          // Orange '+' Button
          GestureDetector(
            onTap: onAddPostTap,
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.38),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 26.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
