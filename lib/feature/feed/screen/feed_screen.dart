import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonScreen(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Airport Feed',
                style: StyleManager.poppinsBold24(AppColors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                'Live community reports and airport gate updates',
                style: StyleManager.interMedium14(AppColors.grayColor),
              ),
              SizedBox(height: 40.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.groups_rounded,
                          color: AppColors.primaryColor,
                          size: 38.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Terminal 5 Updates',
                      style: StyleManager.poppinsBold16(AppColors.black),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Security checkpoint wait time: ~12 minutes.\nGate B24 boarding commences on time at 08:00 AM.',
                      textAlign: TextAlign.center,
                      style: StyleManager.interMedium14(AppColors.darkGrayColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
