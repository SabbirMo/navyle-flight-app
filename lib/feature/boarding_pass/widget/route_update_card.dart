import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteUpdateCard extends StatelessWidget {
  final String title;
  final String message;

  const RouteUpdateCard({
    super.key,
    this.title = 'ROUTE UPDATE',
    this.message = 'Elevator near B20 is out of service. Use stairs at B18.',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1B1108).withValues(alpha: 0.76)
            : const Color(0xffF97316).withValues(alpha: 0.46),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? const Color(0xFFEA580C).withValues(alpha: 0.4)
              : const Color(0xffF97316),
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF97316),
            ),
            child: Center(
              child: Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  message,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : Colors.white.withValues(alpha: 0.95),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
