import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/utils/app_share_helper.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';

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
        return ScaffoldMessenger(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: GestureDetector(
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
  bool _isShareExpanded = false;

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
  }

  bool _isSubmitting = false;

  Future<void> _onShareNavyla() async {
    if (_isSubmitting) return;
    setState(() {
      _isSubmitting = true;
    });

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
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onSocialShare(String channel) {
    AppShareHelper.onSocialShare(context, channel);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final maxAvailableHeight = (screenHeight - viewInsetsBottom) * 0.92;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxHeight: maxAvailableHeight),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blackShadow : Colors.white,
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
                      isDark
                          ? Image.asset(
                              ImageAssets.navylaWhite,
                              height: 24.h,
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              ImageAssets.navyla,
                              height: 24.h,
                              fit: BoxFit.contain,
                            ),
                    ],
                  ),

                  // Review Icon
                  // SvgPicture.asset(ImageAssets.review, width: 105.w),
                  SizedBox(
                    height: 105.h,
                    child: Lottie.asset("assets/lottie/review.json"),
                  ),
                  // Title
                  Text(
                    "How was your trip?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.white : AppColors.blackShadow,
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
                      color: isDark
                          ? Color(0x4DFF9D3E).withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark
                            ? Color(0x4DFF9D3E)
                            : const Color(0xFFFFE0C2),
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
                                        color: isDark
                                            ? Color(
                                                0xffFF9D3E,
                                              ).withValues(alpha: 0.3)
                                            : const Color(0xFFFFF7ED),
                                      ),
                                      Icon(
                                        Icons.star_border_rounded,
                                        size: 38.sp,
                                        color: isDark
                                            ? Color(0xffFF9D3E)
                                            : const Color(0xFFFDBA74),
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
                      color: isDark ? AppColors.white : const Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: isDark ? AppColors.darkBlack : Colors.white,
                      hintText: "Type here",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.lightGray.withValues(alpha: 0.6)
                            : const Color(0xFF94A3B8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.lightGray.withValues(alpha: 0.4)
                              : Color(0xFFCBD5E1),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.lightBlueGray.withValues(alpha: 0.3)
                              : Color(0xFFCBD5E1),
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
                  CustomButton(text: 'Submit Rating', onTap: _onShareNavyla),
                  SizedBox(height: 16.h),

                  // Collapsible Share NAVYLA Card
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBlack
                          : const Color(0xFFFAFBFD),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightGray.withValues(alpha: 0.6)
                            : const Color(0xFFE2E8F0),
                        width: 1.0,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Card Header (tap to toggle expand/collapse)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isShareExpanded = !_isShareExpanded;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Share NAVYLA with friends & family",
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? AppColors.lightGray
                                          : const Color(0xFF495B70),
                                    ),
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _isShareExpanded ? 0.0 : 0.5,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 22.sp,
                                    color: isDark
                                        ? AppColors.white80
                                        : const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Expandable Social Options
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: _isShareExpanded
                              ? Container(
                                  width: double.infinity,
                                  color: isDark
                                      ? AppColors.reviewGray
                                      : Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16.h,
                                    horizontal: 8.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildShareOption(
                                        context: context,
                                        iconWidget: SvgPicture.asset(
                                          ImageAssets.whatsApp,

                                          width: 44.w,
                                          height: 44.w,
                                        ),
                                        label: "WhatsApp",
                                        onTap: () => _onSocialShare("WhatsApp"),
                                      ),
                                      _buildShareOption(
                                        context: context,
                                        iconWidget: SvgPicture.asset(
                                          ImageAssets.message,
                                          width: 44.w,
                                          height: 44.w,
                                        ),
                                        label: "Messages",
                                        onTap: () => _onSocialShare("Messages"),
                                      ),
                                      _buildShareOption(
                                        context: context,
                                        iconWidget: SvgPicture.asset(
                                          ImageAssets.mail,
                                          width: 44.w,
                                          height: 44.w,
                                        ),
                                        label: "Email",
                                        onTap: () => _onSocialShare("Email"),
                                      ),
                                      _buildShareOption(
                                        context: context,
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
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
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
                    color: isDark
                        ? AppColors.white.withValues(alpha: 0.3)
                        : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: isDark
                        ? null
                        : Border.all(
                            color: const Color(0xFFE2E8F0),
                            width: 1.0,
                          ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 16.sp,
                      color: isDark ? AppColors.white : const Color(0xFF64748B),
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
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.white : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
