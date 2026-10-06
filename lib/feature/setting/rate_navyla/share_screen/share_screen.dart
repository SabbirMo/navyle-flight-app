import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  void _onSocialShare(BuildContext context, String channel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sharing via $channel..."),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Custom Back Button with Centered Logo
            CustomBackButton(image: ImageAssets.navyla, imageSize: 110.w),

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
                      style: StyleManager.sfProBold24(AppColors.blackShadow)
                          .copyWith(
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
                        color: AppColors.blackShadow,
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
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // 1. Dark Navy Card ("From Home to Gate")
                    GestureDetector(
                      onTap: () => _onSocialShare(context, "NAVYLA link"),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C2A3F),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    ImageAssets.navylaWhite,
                                    height: 28.h,
                                    fit: BoxFit.contain,
                                  ),

                                  Text(
                                    "From Home to Gate",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffC4C4C4),
                                    ),
                                  ),

                                  Text(
                                    "navyla.app",
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 15.sp,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // 2. White Social Sharing Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 14.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(
                          color: const Color(0xFFF1F5F9),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildShareOption(
                            iconWidget: ImageAssets.whatsApp,
                            label: "WhatsApp",
                            onTap: () => _onSocialShare(context, "WhatsApp"),
                          ),
                          _buildShareOption(
                            iconWidget: ImageAssets.message,
                            label: "Messages",
                            onTap: () => _onSocialShare(context, "Messages"),
                          ),
                          _buildShareOption(
                            iconWidget: ImageAssets.mail,
                            label: "Email",
                            onTap: () => _onSocialShare(context, "Email"),
                          ),
                          _buildShareOption(
                            iconWidget: ImageAssets.smore,
                            label: "More",
                            onTap: () => _onSocialShare(context, "More"),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildShareOption({
    required String iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          SvgPicture.asset(iconWidget, width: 36.w, height: 36.h),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.lightBlueGray,
            ),
          ),
        ],
      ),
    );
  }
}
