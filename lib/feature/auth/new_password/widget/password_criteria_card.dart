import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class PasswordCriteriaCard extends StatelessWidget {
  final bool hasMinLength;
  final bool hasSpecialChar;
  final bool hasUppercase;

  const PasswordCriteriaCard({
    super.key,
    required this.hasMinLength,
    required this.hasSpecialChar,
    required this.hasUppercase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.45),
          width: 1.1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppString.mustContainAtLeast,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          _buildCriteriaItem(
            isSatisfied: hasMinLength,
            label: AppString.eightCharactersMinimum,
          ),
          SizedBox(height: 8.h),
          _buildCriteriaItem(
            isSatisfied: hasSpecialChar,
            label: AppString.oneSpecialCharacter,
          ),
          SizedBox(height: 8.h),
          _buildCriteriaItem(
            isSatisfied: hasUppercase,
            label: AppString.oneUppercaseLetter,
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaItem({
    required bool isSatisfied,
    required String label,
  }) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 16.sp,
          color: isSatisfied
              ? const Color(0xFF22C55E)
              : const Color(0xFF94A3B8),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: StyleManager.interMedium12(AppColors.darkGrayColor),
          ),
        ),
      ],
    );
  }
}
