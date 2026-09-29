import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';

class TerminalBottomSheet extends StatelessWidget {
  final TerminalRouteInfo terminalInfo;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onDetailsTap;

  const TerminalBottomSheet({
    super.key,
    required this.terminalInfo,
    required this.onBookmarkTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        10.h,
        20.w,
        bottomPadding > 0 ? bottomPadding + 8.h : 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 14.h),

          // Title & Bookmark Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  terminalInfo.terminalName,
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onBookmarkTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: terminalInfo.isBookmarked
                        ? const Color(0xFFDBEAFE)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFBFDBFE),
                      width: 0.8,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      terminalInfo.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_outline_rounded,
                      size: 22.sp,
                      color: AppColors.blue2563EB,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Weather/AQI badge and Location Row
          Row(
            children: [
              // Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      '${terminalInfo.temperature} • ${terminalInfo.aqi}',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),

              // Location
              Expanded(
                child: Text(
                  terminalInfo.airportName,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
