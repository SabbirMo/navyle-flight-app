import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/main_image_size.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/setting/rate_navyla/share_screen/widget/social_share_options_card.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Custom Back Button with Centered Logo
            CustomBackButton(
              image: isDark ? ImageAssets.navylaWhite : ImageAssets.navyla,
              imageSize: 110.w,
              isBorder: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 28.h),

                    // Title 1: SHARE NAVYLA
                    Text(
                      "SHARE NAVYLA",
                      textAlign: TextAlign.center,
                      style:
                          StyleManager.sfProBold24(
                            isDark ? AppColors.white : AppColors.blackShadow,
                          ).copyWith(
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w900,
                            fontSize: 19.sp,
                          ),
                    ),
                    SizedBox(height: 18.h),

                    // Title 2: Share NAVYLA with friends & family
                    Text(
                      "Share NAVYLA with friends & family",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.white80
                            : AppColors.blackShadow,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Subtitle
                    Text(
                      "Help make every airport journey easier.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.grayD3D3D3
                            : const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 1. Dark Navy Card ("From Home to Gate")
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C2A3F),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MainImageSize(size: 110.w),
                          Image.asset(
                            ImageAssets.navylaWhite,
                            height: 42.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Made for Travelers",
                            style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                              color: AppColors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "From Home to Gate",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              color: Color(0xffC4C4C4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // 2. Social Sharing Card
                    const SocialShareOptionsCard(),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
