import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

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
                'My Tickets',
                style: StyleManager.poppinsBold24(AppColors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                'View and manage your active boarding passes',
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
                          Icons.confirmation_number_rounded,
                          color: AppColors.primaryColor,
                          size: 38.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'Active Flight Pass Available',
                      style: StyleManager.poppinsBold16(AppColors.black),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Flight BA 0215 to Frankfurt (FRA)\nGate B24 • Seat 14A',
                      textAlign: TextAlign.center,
                      style: StyleManager.interMedium14(
                        AppColors.darkGrayColor,
                      ),
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
