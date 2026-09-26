import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? greeting;
  final String? userName;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onSettingsTap;

  const HomeHeaderWidget({
    super.key,
    this.avatarUrl,
    this.greeting,
    this.userName,
    this.onAvatarTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // User Avatar
        GestureDetector(
          onTap: onAvatarTap,
          child: Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(ImageAssets.profile, fit: BoxFit.cover),
            ),
          ),
        ),
        SizedBox(width: 12.w),

        // Greeting & User Name
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              greeting ?? AppString.goodMorning,
              style: StyleManager.interMedium12(AppColors.darkGrayColor),
            ),

            Text(
              userName ?? AppString.defaultUserName,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const Spacer(),

        // App Logo Pin
        Image.asset(
          ImageAssets.appLogo,
          width: 34.w,
          height: 34.w,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 6.w),

        // Settings Button
        GestureDetector(
          onTap: onSettingsTap,
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.04),
                width: 1,
              ),
            ),
            child: Center(child: SvgPicture.asset(ImageAssets.notification)),
          ),
        ),
      ],
    );
  }
}
