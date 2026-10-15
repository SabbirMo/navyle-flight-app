import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/utils/getting.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? avatarUrl;
  final String? userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final bool hasUnread;

  const HomeHeaderWidget({
    super.key,
    this.avatarUrl,
    this.userName,
    this.onNotificationTap,
    this.onSettingsTap,
    this.hasUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // User Avatar
        GestureDetector(
          onTap: onSettingsTap,
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
              "${Getting.getGreeting()}, ",
              style: StyleManager.interMedium12(
                isDark ? AppColors.grayD3D3D3 : AppColors.darkGrayColor,
              ),
            ),

            Text(
              userName ?? AppString.defaultUserName,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ],
        ),

        const Spacer(),

        // App Logo Pin
        Image.asset(
          ImageAssets.appLogo,
          width: 38.w,
          height: 38.w,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 6.w),

        // Notification Button
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.14)
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: isDark
                    ? Color(0xff000000)
                    : Colors.black.withValues(alpha: 0.04),
                width: 1.8,
              ),
            ),
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    ImageAssets.notification,
                    colorFilter: ColorFilter.mode(
                      isDark ? AppColors.white : AppColors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  if (hasUnread)
                    Positioned(
                      top: -2,
                      right: 0,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
