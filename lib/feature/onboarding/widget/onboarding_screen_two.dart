import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_manager.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_dots_indicator.dart';

class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _animations.buttonTransition(
          child: SizedBox(
            height: 260.w,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Back tilted card (sand/beige boarding ticket)
                  Positioned(
                    right: -16.w,
                    top: -16.h,
                    child: Transform.rotate(
                      angle: 0.20,
                      child: Container(
                        width: 116.w,
                        height: 104.h,
                        decoration: BoxDecoration(
                          color: AppColors.rotateCont,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),

                  // Front White Boarding Card
                  boardingCard(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 38.h),
        _animations.taglineTransition(child: const OnboardingDotsIndicator()),
        SizedBox(height: 18.h),
        _animations.textTransition(
          child: Text(
            AppString.onboardingTitle2,
            style: StyleManager.semiBoldRoboto20(AppColors.black),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
        _animations.taglineTransition(
          child: Text(
            AppString.onboardingDescription2,
            style: StyleManager.interMedium12(AppColors.grayColor),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget boardingCard() {
    return Container(
      width: 306.w,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Icon + AA 123 + On Time
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEFE3),
                  shape: BoxShape.circle,
                ),
                child: Center(child: SvgPicture.asset(ImageManager.flight)),
              ),
              SizedBox(width: 10.w),
              Text(
                "AA 123",
                style: StyleManager.interMedium14(AppColors.black),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  "On Time",
                  style: StyleManager.interMedium12(
                    AppColors.green.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Route Row: JFK -> LHR
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Departure
              destination(code: "JFK", city: "New York"),

              // Flight path trajectory
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 1.5.h,
                    color: const Color(0xFFE5E7EB),
                  ),
                  SizedBox(width: 6.w),
                  Transform.rotate(
                    angle: 1.57,
                    child: Icon(
                      Icons.flight,
                      size: 14.sp,
                      color: const Color(0xFFFFB26B),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    width: 14.w,
                    height: 1.5.h,
                    color: const Color(0xFFE5E7EB),
                  ),
                ],
              ),

              // Arrival
              destination(code: "LHR", city: "London"),
            ],
          ),

          SizedBox(height: 16.h),

          // Orange Status Box: Gate & Status
          statusCard(),
        ],
      ),
    );
  }

  Widget destination({required String code, required String city}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(code, style: StyleManager.sfProSemiBold16(AppColors.black)),
        SizedBox(height: 2.h),
        Text(city, style: StyleManager.interMedium14(AppColors.grayColor)),
      ],
    );
  }

  Widget statusCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          distance(status: "Gate", boaring: "B22"),
          distance(
            status: "Status",
            boaring: "Boarding in 45m",
            align: CrossAxisAlignment.end,
          ),
        ],
      ),
    );
  }

  Widget distance({
    required String status,
    required String boaring,
    CrossAxisAlignment? align,
  }) {
    return Column(
      crossAxisAlignment: align ?? CrossAxisAlignment.start,
      children: [
        Text(status, style: StyleManager.interMedium14(AppColors.brown)),
        SizedBox(height: 2.h),
        Text(boaring, style: StyleManager.sfProSemiBold16(AppColors.black)),
      ],
    );
  }
}
