import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/dashed_line.dart';
import 'package:navyla_flight_app/feature/auth/auth_selection/widget/social_auth_button.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class AuthSelectionScreen extends ConsumerStatefulWidget {
  const AuthSelectionScreen({super.key});

  @override
  ConsumerState<AuthSelectionScreen> createState() =>
      _AuthSelectionScreenState();
}

class _AuthSelectionScreenState extends ConsumerState<AuthSelectionScreen>
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
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(ImageAssets.authBg, opacity: AlwaysStoppedAnimation(0.4)),

          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 100.h),
                    _animations.buttonTransition(
                      child: Image.asset(
                        ImageAssets.appLogo,
                        width: 105.w,
                        height: 105.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _animations.textTransition(
                      child: Text(
                        AppString.welcomeToNavyla,
                        textAlign: TextAlign.center,
                        style: StyleManager.poppinsBold28(
                          AppColors.black,
                        ).copyWith(fontSize: 26.sp),
                      ),
                    ),

                    _animations.taglineTransition(
                      child: Text(
                        AppString.authSelectionSubtitle,
                        textAlign: TextAlign.center,
                        style: StyleManager.interMedium14(
                          AppColors.grayColor,
                        ).copyWith(fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                gradient: AppColors.splashGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blackShadow.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 36.h),
              child: _animations.buttonTransition(
                child: Column(
                  children: [
                    SocialAuthButton(
                      text: AppString.continueWithGoogle,
                      icon: SvgPicture.asset(
                        ImageAssets.google,
                        width: 20.w,
                        height: 20.w,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 16.h),
                    SocialAuthButton(
                      text: AppString.continueWithApple,
                      icon: SvgPicture.asset(
                        ImageAssets.apple,
                        width: 20.w,
                        height: 20.w,
                      ),
                      onTap: () {},
                    ),

                    SizedBox(height: 24.h),
                    _deshDivider(),
                    SizedBox(height: 12.h),
                    SocialAuthButton(
                      text: AppString.continueWithEmail,
                      icon: Icon(Icons.email),
                      border: false,
                      onTap: () {
                        if (mounted) {
                          context.push(AppRouterName.loginScreen);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deshDivider() {
    return Row(
      spacing: 4.w,
      children: [
        Expanded(child: DashedLine()),
        Text(
          AppString.orContinueWith,
          style: StyleManager.interMedium12(AppColors.shadowColor),
        ),
        Expanded(child: DashedLine()),
      ],
    );
  }
}
