import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_dots_indicator.dart';

class OnboardingScreenFour extends StatefulWidget {
  const OnboardingScreenFour({super.key});

  @override
  State<OnboardingScreenFour> createState() => _OnboardingScreenFourState();
}

class _OnboardingScreenFourState extends State<OnboardingScreenFour>
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
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Image.asset(
                    ImageAssets.onBoarding2,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 38.h),
        _animations.taglineTransition(child: const OnboardingDotsIndicator()),
        SizedBox(height: 18.h),
        _animations.textTransition(
          child: Text(
            AppString.onboardingTitle4,
            style: StyleManager.semiBoldRoboto20(
              isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10.h),
        _animations.taglineTransition(
          child: Text(
            AppString.onboardingDescription4,
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
