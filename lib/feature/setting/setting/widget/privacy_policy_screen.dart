import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const paragraphs = [
      AppString.privacyPolicyP1,
      AppString.privacyPolicyP2,
      AppString.privacyPolicyP3,
      AppString.privacyPolicyP4,
      AppString.privacyPolicyP5,
      AppString.privacyPolicyP6,
      AppString.privacyPolicyP7,
    ];

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Top App Bar with back button and centered title
            const CustomBackButton(title: AppString.privacyPolicyUpper),
            SizedBox(height: 18.h),

            // Scrollable Privacy Policy Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      AppString.privacyPolicyUpper,
                      style: StyleManager.interBold16(
                        const Color(0xFF000000),
                      ).copyWith(letterSpacing: 0.6),
                    ),
                    SizedBox(height: 14.h),

                    // Paragraphs
                    ...paragraphs.map(_buildParagraph),

                    // Bottom spacing
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.h),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: GoogleFonts.inter(
          fontSize: 13.5.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF000000),
          height: 1.55,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}
