import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

/// Displayed on the Feed screen when the user has no active boarding pass.
class FeedNoActiveJourneyWidget extends StatelessWidget {
  final VoidCallback onScanTap;
  final VoidCallback onManualTap;

  const FeedNoActiveJourneyWidget({
    super.key,
    required this.onScanTap,
    required this.onManualTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 80.h),
      child: Column(
        children: [
          // 1. Boarding Pass Illustration with Circular Peach Container
          Image.asset(
            ImageAssets.feedBoardingPass,
            height: 160.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.h),

          // 2. Active Journey Required Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.feedOrange.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_rounded,
                  size: 13.sp,
                  color: AppColors.feedOrange,
                ),
                SizedBox(width: 6.w),
                Text(
                  'ACTIVE JOURNEY REQUIRED',
                  style: GoogleFonts.inter(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.feedOrange,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // 3. Heading
          Text(
            'No active journey',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.blackShadow,
            ),
          ),

          SizedBox(height: 8.h),

          // 4. Subtitle
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Add a flight to see real-time updates and community alerts relevant to your journey.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.lightBlueGray,
                height: 1.45,
              ),
            ),
          ),

          SizedBox(height: 22.h),

          // 5. Scan / Load Boarding Pass Button
          GestureDetector(
            onTap: onScanTap,
            child: Container(
              width: double.infinity,
              height: 44.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9E45), Color(0xFFFA7E23)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFA7E23).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 19.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Scan / Load Boarding Pass',
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          // 6. Enter flight number manually Link
          GestureDetector(
            onTap: onManualTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              child: Text(
                'Enter flight number manually >',
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.feedOrange,
                ),
              ),
            ),
          ),

          SizedBox(height: 18.h),

          // 7. Clutter-Free Guarantee Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFF2E6),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.schedule_rounded,
                      size: 16.sp,
                      color: const Color(0xFFFA7E23),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clutter-free guarantee',
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.blackShadow,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'NAVYLA only delivers real-time passenger alerts and security updates for your specific flight and terminal.',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.darkGrayColor,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 36.h),
        ],
      ),
    );
  }
}
