import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';

class TermsofServiceScreen extends StatelessWidget {
  const TermsofServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const paragraphs = [
      AppString.termsOfServiceP1,
      AppString.termsOfServiceP2,
      AppString.termsOfServiceP3,
      AppString.termsOfServiceP4,
      AppString.termsOfServiceP5,
      AppString.termsOfServiceP6,
    ];

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Top App Bar with back button and centered title
            const CustomBackButton(title: AppString.termsOfServiceUpper),
            SizedBox(height: 18.h),

            // Scrollable Terms Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      AppString.termsOfServiceUpper,
                      style: StyleManager.interBold16(
                        const Color(0xFF000000),
                      ).copyWith(letterSpacing: 0.6),
                    ),
                    SizedBox(height: 6.h),

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
