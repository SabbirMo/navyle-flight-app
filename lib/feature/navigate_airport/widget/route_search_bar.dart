import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class RouteSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onMicTap;
  final VoidCallback? onAvatarTap;
  final String? hintText;
  final FocusNode? focusNode;
  final VoidCallback? onTap;

  const RouteSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.onMicTap,
    this.onAvatarTap,
    this.hintText,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlack : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on_outlined,
            color: AppColors.primaryColor,
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onTap: onTap,
              onChanged: onChanged,
              cursorColor: AppColors.primaryColor,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.white : const Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                hintText: hintText ?? 'Search terminal',
                hintStyle: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.lightGray : const Color(0xFF94A3B8),
                ),
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                onClear?.call();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 6.w),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: isDark ? AppColors.lightGray : const Color(0xFF94A3B8),
                ),
              ),
            ),
          GestureDetector(
            onTap: onMicTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Icon(
                Icons.mic_none_rounded,
                size: 22.sp,
                color: isDark ? AppColors.lightGray : const Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onAvatarTap,
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  ImageAssets.profile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFCBD5E1),
                    child: Icon(Icons.person, size: 18.sp, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
