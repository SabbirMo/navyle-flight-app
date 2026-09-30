import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

/// A card that displays city destination information including
/// real-time weather, temperature, local time, and date with a
/// smooth city skyline background fade matching the exact target design.
class CityWeatherCard extends StatelessWidget {
  final String cityName;
  final String temperature;
  final String weatherCondition;
  final String timeLabel;
  final String localTime;
  final String date;
  final String imagePath;
  final String weatherIconPath;

  const CityWeatherCard({
    super.key,
    this.cityName = 'New York',
    this.temperature = '24°C',
    this.weatherCondition = 'Partly cloudy',
    this.timeLabel = 'Local time',
    this.localTime = '3:18 AM',
    this.date = 'Tue, Apr 23',
    this.imagePath = ImageAssets.city,
    this.weatherIconPath = ImageAssets.cloude,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = 114.h;

        // city.png natural size is 1901 x 544. Spire tip is at x = 946.
        final imgWidth = cardHeight * (1901.0 / 544.0);
        final spireInImg = imgWidth * (946.0 / 1901.0);

        // Anchor the Empire State Building spire precisely at 79.5% of the card width
        // so that all text finishes to the left of the building with a clear gap.
        final spireTargetX = cardWidth * 0.795;
        final imgLeft = spireTargetX - spireInImg;

        return Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              // Ambient soft glow shadow
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              // Soft downward depth shadow
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                blurRadius: 12,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. Skyline Background Image (Empire State Building anchored at ~79.5% on the right)
              Positioned(
                left: imgLeft,
                top: 0,
                bottom: 0,
                width: imgWidth,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    // Fade from transparent on the left to full opacity on the right
                    final fadeStart = ((cardWidth * 0.44 - imgLeft) / imgWidth)
                        .clamp(0.0, 1.0);
                    final fadeEnd = ((cardWidth * 0.70 - imgLeft) / imgWidth)
                        .clamp(0.0, 1.0);

                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.white,
                      ],
                      stops: [0.0, fadeStart, fadeEnd],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),

              // Soft white gradient scrim overlay over the left text area
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: cardWidth * 0.72,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.white,
                        AppColors.white,
                        AppColors.white.withValues(alpha: 0.6),
                        AppColors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.55, 0.85, 1.0],
                    ),
                  ),
                ),
              ),

              // 2. Foreground Card Content (finishes cleanly around ~58-60% of card)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // City Name
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Weather & Local Time Info Row
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Weather Section (Icon + Temp & Condition)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                weatherIconPath,
                                width: 30.w,
                                height: 26.h,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    temperature,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black,
                                      height: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    weatherCondition,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(width: 12.w),

                          // Vertical Divider
                          Container(
                            width: 1.2.w,
                            height: 38.h,
                            color: AppColors.grayColor.withValues(alpha: 0.5),
                          ),

                          SizedBox(width: 12.w),

                          // Local Time Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeLabel,
                                style: StyleManager.interMedium12(
                                  AppColors.black,
                                ).copyWith(fontSize: 10.5.sp),
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                localTime,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 1.5.h),
                              Text(
                                date,
                                style: StyleManager.interMedium12(
                                  AppColors.black,
                                ).copyWith(fontSize: 10.5.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
