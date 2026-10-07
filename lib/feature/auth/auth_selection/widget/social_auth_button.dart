import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class SocialAuthButton extends StatelessWidget {
  const SocialAuthButton({
    required this.text,
    required this.icon,
    this.onTap,
    this.isLoading = false,
    super.key,
    this.border = true,
    this.bgColor = false,
  });
  final String text;
  final Widget icon;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool border;
  final bool? bgColor;
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 44.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor == true
            ? Colors.transparent
            : isDark
            ? AppColors.textFieldBgColor
            : AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: border
            ? Border.all(
                color: AppColors.shadowColor.withValues(alpha: 0.3),
                width: 1.2,
              )
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.r),
        onTap: onTap,
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.blackShadow,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 18.w, height: 18.w, child: icon),
                  SizedBox(width: 10.w),
                  Text(
                    text,
                    style: StyleManager.sfProSemiBold14(
                      isDark ? AppColors.white : AppColors.blackShadow,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
