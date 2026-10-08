import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';

/// Card displayed on the Home screen when the user has not added
/// a boarding pass yet (first time or empty state).
class NoActiveJourneyCard extends StatelessWidget {
  final VoidCallback onScanTap;
  final VoidCallback? onViewOfferTap;

  const NoActiveJourneyCard({
    super.key,
    required this.onScanTap,
    this.onViewOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: isDark ? Color(0xff5B6377) : null,
        gradient: isDark
            ? null
            : const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.noActiveBgColor,
                  AppColors.noActiveHighlightBgColor,
                ],
              ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Airplane Icon & "No active journey"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.flight_takeoff_rounded,
                    color: const Color(0xFF1E293B),
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No active journey',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                  Text(
                    'Ready for your next trip?',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : AppColors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Scan/Load Boarding Pass Button
          CustomButton(
            text: 'Scan/Load Boarding Pass',
            prefixIcon: Icons.qr_code_scanner_rounded,
            height: 32.h,
            onTap: onScanTap,
          ),

          SizedBox(height: 10.h),

          // Sponsored Flight Offer Banner
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.5.r),
              child: Stack(
                children: [
                  // Barcelona scenic photo
                  Image.asset(
                    ImageAssets.barcelonaOffer,
                    width: double.infinity,
                    height: 98.h,
                    fit: BoxFit.cover,
                  ),

                  // Gradient overlay on left for readable text
                  Container(
                    width: double.infinity,
                    height: 98.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const [0.0, 0.40, 0.70, 1.0],
                        colors: [
                          Colors.white.withValues(alpha: 0.95),
                          Colors.white.withValues(alpha: 0.88),
                          Colors.white.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  // Airplane badge icon on top right
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDEE5F5),
                        borderRadius: BorderRadius.circular(9.r),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Icon(
                            Icons.flight_rounded,
                            size: 16.sp,
                            color: const Color(0xFF334155),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Text content and CTA
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // SPONSORED Tag
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'SPONSORED',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.5.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFFD97706),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              SizedBox(height: 3.h),

                              // Heading
                              Text(
                                'Flights from Brussels to\nBarcelona',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E293B),
                                  height: 1.18,
                                ),
                              ),
                              SizedBox(height: 2.5.h),

                              // Price
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.inter(
                                    fontSize: 10.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                  children: [
                                    const TextSpan(text: 'From '),
                                    TextSpan(
                                      text: '€49',
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFEA580C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 4.h),

                              // View offer button
                              GestureDetector(
                                onTap: onViewOfferTap,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1.5),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    'View offer →',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFEA580C),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
