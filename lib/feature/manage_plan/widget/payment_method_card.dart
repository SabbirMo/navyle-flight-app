import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class PaymentMethodCard extends StatelessWidget {
  final String cardTitle;
  final String expiryDate;
  final VoidCallback? onUpdateTap;

  const PaymentMethodCard({
    super.key,
    this.cardTitle = "Visa •• 4821",
    this.expiryDate = "Expires 09/28",
    this.onUpdateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.lightGray.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.blackShadow.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card_rounded,
            size: 24.sp,
            color: const Color(0xFF8E9BAE),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  cardTitle,
                  style: StyleManager.sfProSemiBold16(AppColors.black),
                ),

                Text(
                  expiryDate,
                  style: StyleManager.interMedium12(AppColors.lightGray),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onUpdateTap,
            child: Text(
              "Update",
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.subscribeBg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
