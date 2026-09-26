import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.icon = Icons.arrow_back_ios_new_rounded,
    this.title = '',
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.blackShadow.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 14.sp, color: AppColors.black),
        ),
      ),
    );

    if (title.isEmpty) {
      return button;
    }

    return Row(
      children: [
        button,
        Expanded(
          child: Center(
            child: Text(
              title,
              style: StyleManager.sfProSemiBold16(AppColors.blackShadow),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 36.w),
      ],
    );
  }
}
