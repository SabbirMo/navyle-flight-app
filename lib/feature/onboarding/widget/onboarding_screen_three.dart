import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_dots_indicator.dart';

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree>
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  // 1. Back-most card (top layer edge peeking out)
                  Positioned(
                    top: -38.h,
                    child: Container(
                      width: 270.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 12,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Middle card (DELAYED notification)
                  Positioned(
                    top: -24.h,
                    child: Container(
                      width: 300.w,
                      height: 75.h,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B).withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 18,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_filled_rounded,
                                size: 13.sp,
                                color: const Color(
                                  0xFFF87171,
                                ).withValues(alpha: 0.4),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "DELAYED",
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(
                                    0xFFF87171,
                                  ).withValues(alpha: 0.6),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "2m ago",
                            style: StyleManager.interMedium12(
                              isDark
                                  ? AppColors.lightGray.withValues(alpha: 0.4)
                                  : AppColors.shadowColor.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Front Main Card (NOW BOARDING notification)
                  Container(
                    width: 326.w,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(26.r),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.35)
                              : const Color(0x14000000),
                          blurRadius: 28,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Pill Badge + "Now"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : AppColors.shadowColor.withValues(
                                        alpha: 0.1,
                                      ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.flight_takeoff_rounded,
                                    size: 15.sp,
                                    color: isDark
                                        ? const Color(0xFF93C5FD)
                                        : AppColors.shadowColor,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "NOW BOARDING",
                                    style: StyleManager.interMedium12(
                                      isDark
                                          ? const Color(0xFF93C5FD)
                                          : AppColors.shadowColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "Now",
                              style: StyleManager.interMedium12(
                                AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),

                        // Group 3
                        Text(
                          "Group 3",
                          style: StyleManager.interMedium14(
                            isDark ? AppColors.lightGray : AppColors.brown,
                          ),
                        ),

                        // Boarding pass ready text + QR scanner icon
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Have your boarding pass ready.",
                                style: StyleManager.sfProSemiBold16(
                                  isDark ? AppColors.white : AppColors.black,
                                ).copyWith(fontSize: 14.5.sp),
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF3F4F6),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 20,
                                  color: isDark
                                      ? AppColors.white
                                      : const Color(0xFF1F2937),
                                ),
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
          ),
        ),
        SizedBox(height: 38.h),
        _animations.taglineTransition(child: const OnboardingDotsIndicator()),
        SizedBox(height: 18.h),
        _animations.textTransition(
          child: Text(
            AppString.onboardingTitle3,
            style: StyleManager.semiBoldRoboto20(
              isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
        _animations.taglineTransition(
          child: Text(
            AppString.onboardingDescription3,
            style: StyleManager.interMedium12(
              isDark ? AppColors.lightGray : AppColors.grayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
