import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class StressFreeBadge extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const StressFreeBadge({
    super.key,
    required this.title,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isDark
              ? (isActive
                    ? const Color(0xFF071426).withValues(alpha: 0.88)
                    : Colors.black.withValues(alpha: 0.65))
              : (isActive
                    ? const Color(0xff548EEF)
                    : Colors.black.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isDark
                ? const Color(0xFF1D4ED8).withValues(alpha: 0.6)
                : Colors.white.withValues(alpha: 0.25),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
