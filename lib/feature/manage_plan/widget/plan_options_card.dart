import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/setting_toggle_switch.dart';

class PlanOptionsCard extends StatelessWidget {
  final bool isAutoRenew;
  final ValueChanged<bool> onAutoRenewChanged;
  final VoidCallback? onSwitchToYearly;
  final VoidCallback? onCancelSubscription;

  const PlanOptionsCard({
    super.key,
    required this.isAutoRenew,
    required this.onAutoRenewChanged,
    this.onSwitchToYearly,
    this.onCancelSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
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
      child: Column(
        children: [
          // 1. Auto-renew row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Auto-renew",
                        style: StyleManager.sfProSemiBold16(
                          AppColors.blackShadow,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Will renew automatically each month",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: StyleManager.interMedium12(
                          Color(0xff848484),
                        ).copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
                SettingToggleSwitch(
                  value: isAutoRenew,
                  onChanged: onAutoRenewChanged,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1,
              thickness: 0.8,
              color: AppColors.lightGray.withValues(alpha: 0.4),
            ),
          ),

          // 2. Upgrade to Yearly row
          InkWell(
            onTap: onSwitchToYearly,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  SvgPicture.asset(
                    ImageAssets.king,
                    width: 20.w,
                    height: 18.h,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF8E9BAE),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Upgrade to Yearly",
                          style: StyleManager.sfProSemiBold16(AppColors.black),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Save 50% · \$4.92/mo",
                          style: StyleManager.interRegular14(
                            AppColors.lightGray,
                          ).copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Switch",
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.subscribeBg,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1,
              thickness: 0.8,
              color: AppColors.lightGray.withValues(alpha: 0.4),
            ),
          ),

          // 3. Cancel Subscription
          InkWell(
            onTap: onCancelSubscription,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r),
              bottomRight: Radius.circular(24.r),
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Text(
                "Cancel subscription",
                style: StyleManager.sfProSemiBold14(
                  AppColors.subscribeBg,
                ).copyWith(color: const Color(0xFFFF383C)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
