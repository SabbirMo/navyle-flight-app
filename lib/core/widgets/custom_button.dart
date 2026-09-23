import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? iconColor;
  final double? iconSize;
  final bool boxShadow;
  final bool isLoading;
  final bool isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.icon,
    this.width = double.infinity,
    this.height,
    this.borderRadius,
    this.iconColor = AppColors.white,
    this.iconSize,
    this.boxShadow = false,
    this.isLoading = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 30.r;
    final bool canTap = isEnabled && !isLoading && onTap != null;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: height ?? 38.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: isEnabled ? AppColors.primaryColor : AppColors.unSelectColor,
        boxShadow: boxShadow
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.42),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: canTap ? onTap : null,
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: StyleManager.interSemiBold14(AppColors.white),
                      ),
                      if (icon != null) ...[
                        SizedBox(width: 6.w),
                        Icon(
                          icon,
                          color: isEnabled
                              ? iconColor
                              : const Color(0xFF9CA3AF),
                          size: iconSize ?? 16.sp,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
