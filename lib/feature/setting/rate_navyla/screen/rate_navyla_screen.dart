import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';

class RateNavylaScreen extends StatefulWidget {
  const RateNavylaScreen({super.key});

  @override
  State<RateNavylaScreen> createState() => _RateNavylaScreenState();
}

class _RateNavylaScreenState extends State<RateNavylaScreen> {
  int _selectedRating = 1;
  final TextEditingController _experienceController = TextEditingController();

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }

  void _onShareNavyla() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8.w),
            const Expanded(
              child: Text(
                "Thank you for sharing your experience!",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
    Navigator.of(context).maybePop();
  }

  void _onSocialShare(String channel) {
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
            // Top App Bar with Back Button & Centered NAVYLA Logo
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackShadow.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14.sp,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      ImageAssets.navyla,
                      height: 28.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lottie Review Animation
                    Lottie.asset(ImageAssets.reviewLottie, height: 160.h),

                    // Title
                    Text(
                      "How was your trip?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.blackShadow,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Subtitle
                    Text(
                      "We're constantly improving. How was your experience with NAVYLA today?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGray,
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // 5 Star Rating Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFFFE0C2),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= _selectedRating;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRating = starIndex;
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: isFilled
                                  ? Icon(
                                      Icons.star_rounded,
                                      size: 36.sp,
                                      color: const Color(0xFFFF942B),
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          size: 36.sp,
                                          color: const Color(0xFFFFF7ED),
                                        ),
                                        Icon(
                                          Icons.star_border_rounded,
                                          size: 36.sp,
                                          color: const Color(0xFFFDBA74),
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Share experience label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Share your experience (Optional)",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightGray,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Experience text input
                    Container(
                      height: 96.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 1.0,
                        ),
                      ),
                      child: TextField(
                        controller: _experienceController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF1E293B),
                        ),
                        decoration: InputDecoration(
                          hintText: "Type here",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF94A3B8),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFCBD5E1),
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Share NAVYLA Button
                    CustomButton(
                      text: "Share NAVYLA",
                      prefixIcon: Icons.file_upload_outlined,
                      iconSize: 20.sp,
                      height: 44.h,
                      borderRadius: 24.r,
                      onTap: _onShareNavyla,
                    ),
                    SizedBox(height: 16.h),

                    // Share with friends & family title
                    Text(
                      "Share with friends & family",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.lightGray,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Social Icons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildShareOption(
                          iconWidget: SvgPicture.asset(ImageAssets.whatsApp),
                          label: "WhatsApp",
                          onTap: () => _onSocialShare("WhatsApp"),
                        ),
                        _buildShareOption(
                          iconWidget: SvgPicture.asset(ImageAssets.message),
                          label: "Messages",
                          onTap: () => _onSocialShare("Messages"),
                        ),
                        _buildShareOption(
                          iconWidget: SvgPicture.asset(ImageAssets.mail),
                          label: "Email",
                          onTap: () => _onSocialShare("Email"),
                        ),
                        _buildShareOption(
                          iconWidget: SvgPicture.asset(ImageAssets.smore),
                          label: "More",
                          onTap: () => _onSocialShare("More"),
                        ),
                      ],
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
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            alignment: Alignment.center,
            child: iconWidget,
          ),
          SizedBox(height: 6.h),
          Text(label, style: StyleManager.interBold10(AppColors.lightBlueGray)),
        ],
      ),
    );
  }
}
