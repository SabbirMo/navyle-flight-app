import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

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
    this.cityName = 'Frankfurt',
    this.temperature = '24°C',
    this.weatherCondition = 'Partly cloudy',
    this.timeLabel = 'Local time',
    this.localTime = '9:41 AM',
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

        // Precise skyline alignment coordinates for city.png (2000 x 1333):
        // Height window: 680px (starting from y = 315px)
        // Right anchor: x = 1265px
        final imgHeight = cardHeight * (1333.0 / 680.0);
        final imgWidth = cardHeight * (2000.0 / 680.0);
        final topOffset = -cardHeight * (315.0 / 680.0);
        final rightOffset = -cardHeight * ((2000.0 - 1265.0) / 680.0);
        final imgLeft = cardWidth - imgWidth - rightOffset;

        return Container(
          width: double.infinity,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              // Ambient soft glow shadow
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              // Downward depth shadow
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 1. Frankfurt Skyline Background with seamless linear gradient fade
              Positioned(
                left: imgLeft,
                top: topOffset,
                width: imgWidth,
                height: imgHeight,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    final fadeStartInBounds = (cardWidth * 0.44 - imgLeft)
                        .clamp(0.0, bounds.width);
                    final fadeEndInBounds = (cardWidth * 0.72 - imgLeft).clamp(
                      0.0,
                      bounds.width,
                    );
                    final stopStart = fadeStartInBounds / bounds.width;
                    final stopEnd = fadeEndInBounds / bounds.width;

                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: const [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.white,
                      ],
                      stops: [0.0, stopStart, stopEnd],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    imagePath,
                    width: imgWidth,
                    height: imgHeight,
                    fit: BoxFit.fill,
                  ),
                ),
              ),

              // 2. Soft white gradient overlay across the left side for optimal legibility
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: cardWidth * 0.68,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        AppColors.white,
                        AppColors.white,
                        AppColors.white.withValues(alpha: 0.8),
                        AppColors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.44, 0.65, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Foreground Information Layer
              Padding(
                padding: EdgeInsets.only(
                  left: 18.w,
                  top: 14.h,
                  right: 18.w,
                  bottom: 12.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // City Name
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.2,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Weather, Divider, and Local Time Row
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
                                width: 34.w,
                                height: 30.h,
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
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                      height: 1.15,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    weatherCondition,
                                    style: TextStyle(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF334155),
                                      height: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(width: 14.w),

                          // Vertical Divider
                          Container(
                            width: 1.2.w,
                            height: 42.h,
                            color: const Color(0xFFBAC0C9),
                          ),

                          SizedBox(width: 14.w),

                          // Local Time Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                timeLabel,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF334155),
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                localTime,
                                style: TextStyle(
                                  fontSize: 19.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF475569),
                                  height: 1.1,
                                ),
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
