import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';

class TravelExtraWidget extends StatelessWidget {
  const TravelExtraWidget({super.key, required this.data, required this.onTap});

  final MoreModel data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBlack : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: isDark
              ? Border.all(
                  color: AppColors.lightBlueGray.withValues(alpha: 0.4),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xff22252F)
                    : AppColors.primaryFeed.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12.r),
                border: isDark
                    ? Border.all(
                        color: AppColors.primaryFeed.withValues(alpha: 0.2),
                      )
                    : null,
              ),
              child: Center(
                child: SvgPicture.asset(
                  data.image,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: StyleManager.interMedium14(
                      isDark
                          ? AppColors.white.withValues(alpha: 0.8)
                          : AppColors.black,
                    ).copyWith(fontSize: 13.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    data.subtitle,
                    style: StyleManager.interMedium12(
                      isDark
                          ? AppColors.grayD3D3D3.withValues(alpha: 0.7)
                          : AppColors.lightBlueGray,
                    ).copyWith(fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.lightBlueGray,
            ),
          ],
        ),
      ),
    );
  }
}
