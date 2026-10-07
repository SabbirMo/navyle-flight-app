import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';
import 'package:navyla_flight_app/feature/more/screen/partner_website_screen.dart';

class MoreDetailsScreen extends StatefulWidget {
  const MoreDetailsScreen({super.key, required this.data});

  final MoreModel data;

  @override
  State<MoreDetailsScreen> createState() => _MoreDetailsScreenState();
}

class _MoreDetailsScreenState extends State<MoreDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBackButton(
                  title: widget.data.title,
                  subTitle: "Offers from NAVYLA partners",
                  isBorder: true,
                ),
                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Color(0x1AEDF3F8) : Color(0xffEDF3F8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    AppString.suggestion,
                    style: StyleManager.interMedium12(
                      AppColors.lightBlueGray,
                    ).copyWith(fontSize: 11.sp),
                  ),
                ),

                SizedBox(height: 16.h),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkBlack : AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isDark
                        ? Border.all(
                            color: AppColors.lightBlueGray.withValues(
                              alpha: 0.4,
                            ),
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "PARTNER OFFERS",
                        style: StyleManager.interMedium12(
                          isDark
                              ? AppColors.grayD3D3D3.withValues(alpha: 0.7)
                              : AppColors.lightBlueGray,
                        ).copyWith(fontSize: 11.sp),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.data.partnerText,

                        style: StyleManager.interSemiBold14(
                          isDark ? AppColors.white80 : AppColors.black,
                        ),
                      ),

                      SizedBox(height: 10.h),
                      Text(
                        widget.data.partnerSubText,

                        style: StyleManager.interMedium12(
                          isDark
                              ? AppColors.grayD3D3D3.withValues(alpha: 0.7)
                              : AppColors.lightBlueGray,
                        ).copyWith(fontSize: 11.sp),
                      ),

                      SizedBox(height: 12.h),

                      CustomButton(
                        text: "Continue to partner",
                        height: 36.h,
                        borderRadius: 18.r,
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) =>
                                  PartnerWebsiteScreen(data: widget.data),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  AppString.partnerText,
                  textAlign: TextAlign.center,
                  style: StyleManager.interMedium12(
                    isDark
                        ? AppColors.grayD3D3D3.withValues(alpha: 0.7)
                        : AppColors.lightBlueGray,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
