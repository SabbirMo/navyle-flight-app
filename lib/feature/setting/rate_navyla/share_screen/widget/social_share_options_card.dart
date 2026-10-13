import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/utils/app_share_helper.dart';

/// A reusable social sharing options card that provides
/// WhatsApp, Messages, Email, and More (System Share Sheet via share_plus).
class SocialShareOptionsCard extends StatelessWidget {
  final String shareText;
  final String shareSubject;
  final void Function(String channel)? onChannelTap;

  const SocialShareOptionsCard({
    super.key,
    this.shareText = AppShareHelper.defaultShareText,
    this.shareSubject = AppShareHelper.defaultSubject,
    this.onChannelTap,
  });

  void _handleTap(BuildContext context, String channel) {
    if (onChannelTap != null) {
      onChannelTap!(channel);
      return;
    }

    AppShareHelper.onSocialShare(
      context,
      channel,
      text: shareText,
      subject: shareSubject,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 14.w,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.reviewGray : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? AppColors.lightGray.withValues(alpha: 0.6)
              : const Color(0xFFF1F5F9),
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
            onTap: () => _handleTap(context, "WhatsApp"),
            isDark: isDark,
          ),
          _buildShareOption(
            iconWidget: ImageAssets.message,
            label: "Messages",
            onTap: () => _handleTap(context, "Messages"),
            isDark: isDark,
          ),
          _buildShareOption(
            iconWidget: ImageAssets.mail,
            label: "Email",
            onTap: () => _handleTap(context, "Email"),
            isDark: isDark,
          ),
          _buildShareOption(
            iconWidget: ImageAssets.smore,
            label: "More",
            onTap: () => _handleTap(context, "More"),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required String iconWidget,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
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
              color: isDark ? AppColors.white : AppColors.lightBlueGray,
            ),
          ),
        ],
      ),
    );
  }
}
