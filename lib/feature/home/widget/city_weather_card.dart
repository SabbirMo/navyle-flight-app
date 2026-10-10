import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/home/provider/city_weather_notifier.dart';

class CityWeatherCard extends ConsumerWidget {
  final String? cityName;
  final String? temperature;
  final String? condition;
  final String? localTime;
  final String? date;
  final String? iconAsset;

  const CityWeatherCard({
    super.key,
    this.cityName,
    this.temperature,
    this.condition,
    this.localTime,
    this.date,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(cityWeatherNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveCity = cityName ?? weather.cityName ?? '';
    final effectiveTemp = temperature ?? weather.temperature ?? '';
    final effectiveCondition = condition ?? weather.condition ?? '';
    final effectiveTime = localTime ?? weather.localTime ?? '';
    final effectiveDate = date ?? weather.date ?? '';

    final primaryTextColor = Colors.white;
    final secondaryTextColor = Colors.white.withValues(alpha: 0.75);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),

        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Weather Info (Icon + Temp + Condition)
          Expanded(
            flex: 12,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  iconAsset ?? ImageAssets.cloude,
                  width: 28.w,
                  height: 28.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          effectiveTemp,
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: primaryTextColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          effectiveCondition,
                          maxLines: 1,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider 1
          Container(
            width: 2.w,
            height: 36.h,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
          SizedBox(width: 8.w),

          // 2. City Name
          Expanded(
            flex: 9,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                effectiveCity,
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: primaryTextColor,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),
          // Divider 2
          Container(
            width: 2.w,
            height: 36.h,
            color: AppColors.white.withValues(alpha: 0.8),
          ),
          SizedBox(width: 8.w),

          // 3. Local Time & Date
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Local time',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    effectiveTime,
                    style: TextStyle(
                      fontFamily: 'SF-Pro',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                      height: 1.1,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    effectiveDate,
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
