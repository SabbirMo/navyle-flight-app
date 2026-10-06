import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class RateNavylaBottomSheet extends StatefulWidget {
  const RateNavylaBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(ctx).pop(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.20),
              child: AnimatedPadding(
                padding: EdgeInsets.only(bottom: bottomInset),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap:
                            () {}, // Prevent taps inside bottom sheet from dismissing
                        child: const RateNavylaBottomSheet(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  State<RateNavylaBottomSheet> createState() => _RateNavylaBottomSheetState();
}

class _RateNavylaBottomSheetState extends State<RateNavylaBottomSheet> {
  int _selectedRating = 1;
  final TextEditingController _experienceController = TextEditingController();

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }

  void _onShareNavyla() {
    Navigator.of(context).pop();
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
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final maxAvailableHeight = (screenHeight - viewInsetsBottom) * 0.92;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: maxAvailableHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            // Scrollable Content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 36.h),

                  // NAVYLA Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.appLogo,
                        height: 34.h,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        ImageAssets.navyla,
                        height: 24.h,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  // Review Icon
                  SvgPicture.asset(ImageAssets.review, width: 105.w),

                  // Title
                  Text(
                    "How was your trip?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.blackShadow,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Subtitle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "We're constantly improving. How was your experience with NAVYLA today?",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.lightGray,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // 5-Star Rating Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
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
                                    size: 38.sp,
                                    color: const Color(0xFFFF942B),
                                  )
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        size: 38.sp,
                                        color: const Color(0xFFFFF7ED),
                                      ),
                                      Icon(
                                        Icons.star_border_rounded,
                                        size: 38.sp,
                                        color: const Color(0xFFFDBA74),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Share experience label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share your experience (Optional)",
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Experience text input
                  TextField(
                    controller: _experienceController,
                    maxLines: 4,
                    minLines: 3,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Type here",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12.5.sp,
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
                          color: Color(0xFFFF942B),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Share NAVYLA Button
                  GestureDetector(
                    onTap: _onShareNavyla,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF942B),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF942B,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_upload_outlined,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Share NAVYLA",
                            style: GoogleFonts.inter(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Share with friends & family title
                  Text(
                    "Share with friends & family",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Social Icons Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildShareOption(
                        iconWidget: SvgPicture.asset(
                          ImageAssets.whatsApp,
                          width: 44.w,
                          height: 44.w,
                        ),
                        label: "WhatsApp",
                        onTap: () => _onSocialShare("WhatsApp"),
                      ),
                      _buildShareOption(
                        iconWidget: SvgPicture.asset(
                          ImageAssets.message,
                          width: 44.w,
                          height: 44.w,
                        ),
                        label: "Messages",
                        onTap: () => _onSocialShare("Messages"),
                      ),
                      _buildShareOption(
                        iconWidget: SvgPicture.asset(
                          ImageAssets.mail,
                          width: 44.w,
                          height: 44.w,
                        ),
                        label: "Email",
                        onTap: () => _onSocialShare("Email"),
                      ),
                      _buildShareOption(
                        iconWidget: SvgPicture.asset(
                          ImageAssets.smore,
                          width: 44.w,
                          height: 44.w,
                        ),
                        label: "More",
                        onTap: () => _onSocialShare("More"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),

            // Fixed Top Drag Handle Indicator
            Positioned(
              top: 10.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 44.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
            ),

            // Fixed Top-Right Close Button
            Positioned(
              top: 10.h,
              right: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.sp,
                      color: const Color(0xFF64748B),
                    ),
                  ),
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
          iconWidget,
          SizedBox(height: 6.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
