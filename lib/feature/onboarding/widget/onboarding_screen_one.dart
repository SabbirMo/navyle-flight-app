import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_dots_indicator.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne>
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
          child: ClipOval(
            child: Image.asset(
              ImageAssets.onBoarding1,
              width: 260.w,
              height: 260.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 38.h),
        _animations.taglineTransition(child: const OnboardingDotsIndicator()),
        SizedBox(height: 18.h),
        _animations.textTransition(
          child: Text(
            AppString.onboardingTitle1,
            style: StyleManager.semiBoldRoboto20(
              isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
        _animations.taglineTransition(
          child: Text(
            AppString.onboardingDescription1,
            style: StyleManager.interMedium14(
              isDark ? AppColors.lightGray : AppColors.grayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
