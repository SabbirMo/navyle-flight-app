import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

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
                'More Options',
                style: StyleManager.poppinsBold24(AppColors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                'Manage luggage, lounge access, and preferences',
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
                        child: SvgPicture.asset(
                          ImageAssets.more,
                          width: 36.w,
                          height: 36.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Travel Tools & Settings',
                      style: StyleManager.poppinsBold16(AppColors.black),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Baggage tracker, airport map, flight alerts,\nand account security settings.',
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
