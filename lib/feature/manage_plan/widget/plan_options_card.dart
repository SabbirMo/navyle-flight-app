import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';
import 'package:url_launcher/url_launcher.dart';

class PlanOptionsCard extends ConsumerWidget {
  const PlanOptionsCard({super.key});

  void _showFeedback(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFF0F172A),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Future<void> _openSubscriptionSettings(
    BuildContext context,
    bool isIOS,
  ) async {
    final storeName = isIOS ? "App Store" : "Google Play";
    final url = isIOS
        ? "https://apps.apple.com/account/subscriptions"
        : "https://play.google.com/store/account/subscriptions";

    try {
      final uri = Uri.parse(url);
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final fallback = await launchUrl(uri, mode: LaunchMode.platformDefault);
        if (!fallback && context.mounted) {
          _showFeedback(
            context,
            "Could not open $storeName subscription settings.",
          );
        }
      }
    } catch (e) {
      debugPrint("Could not launch $storeName subscription URL: $e");
      if (context.mounted) {
        _showFeedback(
          context,
          "Could not open $storeName subscription settings.",
        );
      }
    }
  }

  void _showAutoRenewalInfo(BuildContext context, bool isIOS) {
    final storeName = isIOS ? "App Store" : "Google Play";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkBlack : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Auto-renewal",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7ED),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        "Active",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  "Your subscription renews automatically via $storeName. To turn off auto-renewal, cancel, or modify your plan, please manage it in your $storeName account.",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.grayD3D3D3
                        : const Color(0xFF6B7280),
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _openSubscriptionSettings(context, isIOS);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.subscribeBg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Manage in $storeName",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final storeName = isIOS ? "App Store" : "Google Play";

    return Column(
      children: [
        // 1. Billing Card (Managed by Google Play / App Store)
        _buildBillingCard(context, isIOS),
        SizedBox(height: 10.h),

        // 2. Manage Subscription
        _buildOptionTile(
          context: context,
          icon: Icons.settings_outlined,
          title: "Manage Subscription",
          subtitle: "Open $storeName subscription settings",
          onTap: () => _openSubscriptionSettings(context, isIOS),
        ),
        SizedBox(height: 10.h),

        // 3. Restore Purchases (App Store specific)
        if (isIOS) ...[
          _buildOptionTile(
            context: context,
            icon: Icons.refresh_rounded,
            title: "Restore Purchases",
            subtitle: "Re-sync your premium access",
            onTap: () => _showFeedback(context, "Restoring purchases..."),
          ),
          SizedBox(height: 10.h),
        ],

        // 4. Auto-renewal (Store-managed status, NOT a NAVYLA billing switch)
        _buildOptionTile(
          context: context,
          icon: Icons.autorenew_rounded,
          iconSize: 20.sp,
          iconColor: const Color(0xFFF58A38),
          iconBoxColor: const Color(0xFFFFF3E8),
          title: "Auto-renewal",
          subtitle: "Renews automatically via $storeName",
          trailingBadge: "Active",
          trailingBadgeBgColor: const Color(0xFFE8F7ED),
          trailingBadgeTextColor: const Color(0xFF22C55E),
          onTap: () => _showAutoRenewalInfo(context, isIOS),
        ),
        SizedBox(height: 10.h),

        // 5. Upgrade to Yearly
        _buildOptionTile(
          context: context,
          customIcon: SvgPicture.asset(
            ImageAssets.king,
            width: 17.w,
            height: 17.w,
            colorFilter: const ColorFilter.mode(
              Color(0xFFF58A38),
              BlendMode.srcIn,
            ),
          ),
          title: "Upgrade to Yearly",
          subtitle: "Save 50% · \$4.92/mo",
          onTap: () {
            context.push(AppRouterName.subscriptionScreen);
          },
        ),
        SizedBox(height: 10.h),

        // 6. Terms of Service
        _buildOptionTile(
          context: context,
          icon: Icons.description_outlined,
          title: "Terms of Service",
          onTap: () {
            context.push(AppRouterName.termsOfServiceScreen);
          },
        ),
        SizedBox(height: 10.h),

        // 7. Privacy Policy
        _buildOptionTile(
          context: context,
          icon: Icons.shield_outlined,
          title: "Privacy Policy",
          onTap: () {
            context.push(AppRouterName.privacyPolicyScreen);
          },
        ),
        SizedBox(height: 14.h),

        // 8. Bottom Notice Pill
        _buildNoticeCard(context: context, isIOS: isIOS),
      ],
    );
  }

  Widget _buildBillingCard(BuildContext context, bool isIOS) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBlack : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark
              ? AppColors.white.withValues(alpha: 0.6)
              : const Color(0xFFF1F5F9),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Billing",
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.white : AppColors.lightBlueGray,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isIOS
                  ? Icon(
                      Icons.apple,
                      size: 28.sp,
                      color: isDark ? AppColors.white : Colors.black,
                    )
                  : SvgPicture.asset(
                      ImageAssets.playStore,
                      width: 28.w,
                      height: 28.w,
                    ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIOS ? "Managed by App Store" : "Managed by Google Play",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.white
                            : const Color(0xFF111827),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isIOS
                          ? "Your subscription and billing are handled by Apple. You can manage your subscription directly in the App Store."
                          : "Your subscription and billing are handled by Google. You can manage your subscription directly in the Google Play Store.",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.grayD3D3D3.withValues(alpha: 0.9)
                            : const Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    Widget? customIcon,
    IconData? icon,
    double? iconSize,
    Color? iconColor,
    Color? iconBoxColor,
    required String title,
    String? subtitle,
    String? trailingBadge,
    Color? trailingBadgeBgColor,
    Color? trailingBadgeTextColor,
    VoidCallback? onTap,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBlack : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isDark
                ? AppColors.lightGray.withValues(alpha: 0.6)
                : const Color(0xFFF1F5F9),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon in box
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBoxColor ?? const Color(0xFFFFF3E8),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child:
                    customIcon ??
                    Icon(
                      icon,
                      size: iconSize ?? 18.sp,
                      color: iconColor ?? const Color(0xFFF58A38),
                    ),
              ),
            ),
            SizedBox(width: 12.w),

            // Title and Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.white : const Color(0xFF111827),
                    ),
                  ),
                  if (subtitle != null) ...[
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: isDark
                            ? AppColors.grayD3D3D3.withValues(alpha: 0.9)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Trailing widget (Badge or Arrow)
            if (trailingBadge != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: trailingBadgeBgColor ?? const Color(0xFFE8F7ED),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  trailingBadge,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: trailingBadgeTextColor ?? const Color(0xFF22C55E),
                  ),
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 11.sp,
                color: const Color(0xFFCBD5E1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeCard({
    required BuildContext context,
    required bool isIOS,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xB2EBF0F5) : const Color(0xFFEFF4F9),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_rounded,
            size: 17.sp,
            color: isDark ? AppColors.black : const Color(0xFF64748B),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              isIOS
                  ? "Subscription management and billing are handled by Apple App Store, not directly by NAVYLA."
                  : "Subscription management and billing are handled by Google Play, not directly by NAVYLA.",
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: isDark ? AppColors.black : const Color(0xFF64748B),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
