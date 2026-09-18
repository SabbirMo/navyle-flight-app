import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/onboarding/provider/onboarding_provider.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/live_navigation_bottom_sheet.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_screen_four.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_screen_one.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_screen_three.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/onboarding_screen_two.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    ref.read(onboardingProvider.notifier).changeIndex(value);
                  },
                  children: const [
                    OnboardingScreenOne(),
                    OnboardingScreenTwo(),
                    OnboardingScreenThree(),
                    OnboardingScreenFour(),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  text: AppString.nextButton,
                  onTap: () {
                    final currentIndex = ref.read(onboardingProvider);
                    if (currentIndex == 1) {
                      LiveNavigationBottomSheet.show(
                        context,
                        onAllow: () {
                          ref
                              .read(onboardingProvider.notifier)
                              .nextPage(_pageController, 4);
                        },
                        onNotNow: () {
                          ref
                              .read(onboardingProvider.notifier)
                              .nextPage(_pageController, 4);
                        },
                      );
                    } else {
                      ref
                          .read(onboardingProvider.notifier)
                          .nextPage(_pageController, 4);
                    }
                  },
                  icon: Icons.arrow_forward_ios,
                ),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () {
                  _pageController.animateToPage(
                    3,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
                child: Text(
                  AppString.skipButton,
                  style: StyleManager.interMedium12(AppColors.grayColor),
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
