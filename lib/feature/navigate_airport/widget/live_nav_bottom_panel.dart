import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class LiveNavBottomPanel extends StatelessWidget {
  final String duration;
  final String distanceEta;
  final VoidCallback onClose;
  final VoidCallback? onRoutesTap;

  const LiveNavBottomPanel({
    super.key,
    this.duration = '40',
    this.distanceEta = '2.9 km • 9:35 AM',
    required this.onClose,
    this.onRoutesTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20.w,
        14.h,
        20.w,
        bottomPadding > 0 ? bottomPadding + 10.h : 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Close button
          GestureDetector(
            onTap: onClose,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.close_rounded,
                  size: 22.sp,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          // Duration & ETA details
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    duration,
                    style: GoogleFonts.inter(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'min',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Orange footprints icon
                  Icon(
                    Icons.directions_walk_rounded,
                    size: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                distanceEta,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),

          // Alternate routes button
          GestureDetector(
            onTap: onRoutesTap,
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1.2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.alt_route_rounded,
                  size: 22.sp,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
