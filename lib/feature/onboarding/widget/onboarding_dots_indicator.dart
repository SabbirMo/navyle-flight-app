import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/onboarding/provider/onboarding_provider.dart';

class OnboardingDotsIndicator extends ConsumerWidget {
  final int totalDots;
  const OnboardingDotsIndicator({super.key, this.totalDots = 4});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectIndex = ref.watch(onboardingProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: List.generate(totalDots, (i) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 6.h,
          width: selectIndex == i ? 30.w : 8.w,
          decoration: BoxDecoration(
            color: selectIndex == i
                ? AppColors.primaryColor
                : AppColors.unSelectColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
        );
      }),
    );
  }
}
