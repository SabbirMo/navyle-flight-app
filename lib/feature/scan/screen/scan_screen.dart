import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

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
                'Scan Boarding Pass',
                style: StyleManager.poppinsBold24(AppColors.black),
              ),
              SizedBox(height: 8.h),
              Text(
                'Align the QR code or barcode inside the frame to scan',
                style: StyleManager.interMedium14(AppColors.grayColor),
              ),
              SizedBox(height: 48.h),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 220.w,
                      height: 220.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(alpha: 0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: AppColors.primaryColor,
                          size: 72.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      'Ready to Scan',
                      style: StyleManager.poppinsBold16(AppColors.black),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Hold your phone steady in front of the gate code or boarding ticket.',
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
