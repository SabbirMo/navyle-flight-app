import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/theme/theme_mode_provder.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/delete_account_dialog.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/profile_details_card.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/setting_item_tile.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/setting_toggle_switch.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/sign_out_dialog.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/subscription_plan_card.dart';
import 'package:navyla_flight_app/feature/setting/rate_navyla/widget/rate_navyla_bottom_sheet.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  bool isLocationAccess = true;
  bool isPushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            Theme.of(context).brightness == Brightness.dark);

    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            const CustomBackButton(title: "SETTINGS", isBorder: true),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Profile Details
                    _buildSectionTitle("PROFILE DETAILS"),
                    ProfileDetailsCard(
                      onTap: () {
                        context.push(AppRouterName.profileDetailsScreen);
                      },
                    ),
                    SizedBox(height: 18.h),

                    // 2. Subscription Plan
                    _buildSectionTitle("SUBSCRIPTION PLAN"),
                    SubscriptionPlanCard(
                      onManagePlanTap: () {
                        context.push(AppRouterName.managePlanScreen);
                      },
                    ),
                    SizedBox(height: 18.h),

                    // 3. Appearance
                    _buildSectionTitle("APPEARANCE"),
                    SettingCardContainer(
                      children: [
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.nightlight_round,
                            backgroundColor: isDarkMode
                                ? Color(0x1A6366F1)
                                : Color(0xFFFFF3E6),
                            iconColor: isDarkMode
                                ? Color(0xff6366F1)
                                : Color(0xFFFF942B),
                            borderColor: Color(0xff6366F1),
                          ),
                          title: "Dark Mode",
                          subtitle: "Enjoy a darker view",
                          trailing: SettingToggleSwitch(
                            value: isDarkMode,
                            onChanged: (val) {
                              ref
                                  .read(themeModeProvider.notifier)
                                  .set(val ? ThemeMode.dark : ThemeMode.light);
                            },
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // 4. Permissions
                    _buildSectionTitle("PERMISSIONS"),
                    SettingCardContainer(
                      children: [
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.watch_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0x4DFDEDE3)
                                : Color(0xFFFFF1E6),
                            iconColor: Color(0xFFFF8533),
                            borderColor: Color(
                              0xFFFF8533,
                            ).withValues(alpha: 0.4),
                          ),
                          title: "Smartwatch",
                          subtitle: "Apple Watch / Wear OS",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          onTap: () {
                            context.push(AppRouterName.smartWatchScreen);
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.location_on_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0x333B82F6)
                                : Color(0xFFEFF6FF),
                            iconColor: Color(0xFF3B82F6),
                            borderColor: Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.3),
                          ),
                          title: "Location Access",
                          subtitle: "For reliable updates",
                          trailing: SettingToggleSwitch(
                            value: isLocationAccess,
                            onChanged: (val) {
                              setState(() {
                                isLocationAccess = val;
                              });
                            },
                          ),
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.notifications_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0x33F97316)
                                : Color(0xFFFFF3E6),
                            iconColor: Color(0xFFFF8533),
                            borderColor: Color(
                              0xFFFF8533,
                            ).withValues(alpha: 0.3),
                          ),
                          title: "Push Notifications",
                          subtitle: "Quick updates at your notify bar",
                          trailing: SettingToggleSwitch(
                            value: isPushNotifications,
                            onChanged: (val) {
                              setState(() {
                                isPushNotifications = val;
                              });
                            },
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // 5. Support & Legal
                    _buildSectionTitle("SUPPORT & LEGAL"),
                    SettingCardContainer(
                      children: [
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.star_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0x33EAB308)
                                : AppColors.warningColor,
                            iconColor: Color(0xFFEAB308),
                            borderColor: Color(
                              0xFFEAB308,
                            ).withValues(alpha: 0.3),
                          ),
                          title: "RATE NAVYLA",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            RateNavylaBottomSheet.show(context);
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.share_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0x1A2563EB)
                                : Color(0xFFEFF6FF),
                            iconColor: Color(0xFF2563EB),
                          ),
                          title: "SHARE NAVYLA",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            context.push(AppRouterName.shareScreen);
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.description_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0xff1E293B)
                                : Color(0xFFF1F5F9),
                            iconColor: Color(0xFF64748B),
                            borderColor: Color(
                              0xFF64748B,
                            ).withValues(alpha: 0.3),
                          ),
                          title: "TERMS OF SERVICE",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            context.push(AppRouterName.termsOfServiceScreen);
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: SettingIconBox(
                            icon: Icons.security_rounded,
                            backgroundColor: isDarkMode
                                ? Color(0xff1E293B)
                                : Color(0xFFF1F5F9),
                            iconColor: Color(0xFF64748B),
                            borderColor: Color(
                              0xFF64748B,
                            ).withValues(alpha: 0.3),
                          ),
                          title: "PRIVACY POLICY",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            context.push(AppRouterName.privacyPolicyScreen);
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),

                    // 6. Sign Out Account Button
                    SettingActionButton(
                      text: "SIGN OUT ACCOUNT",
                      onTap: () {
                        SignOutDialog.show(
                          context,
                          onSignOut: () {
                            ref.read(navbarNotifierProvider.notifier).reset();
                            context.go(AppRouterName.loginScreen);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 12.h),
                    SettingActionButton(
                      text: "Delete Account",
                      textColor: const Color(0xffBA1A1A),
                      fontSize: 14.sp,
                      onTap: () {
                        DeleteAccountDialog.show(
                          context,
                          onDelete: () {
                            ref.read(navbarNotifierProvider.notifier).reset();
                            context.go(AppRouterName.loginScreen);
                          },
                        );
                      },
                      backgroundColor: const Color(0xffCFC0C0),
                      prefixIcon: Image.asset(ImageAssets.delete, width: 12.w),
                    ),
                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: StyleManager.interBold10(
          AppColors.lightGray,
        ).copyWith(letterSpacing: 0.9),
      ),
    );
  }
}

/// Reusable action button for settings screen (e.g., sign out, delete account, etc.)
class SettingActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final Color? textColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Widget? prefixIcon;

  const SettingActionButton({
    super.key,
    required this.text,
    this.onTap,
    this.textColor,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.fontSize,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor = textColor ?? const Color(0xFFEF4444);
    final effectiveBgColor =
        backgroundColor ?? effectiveTextColor.withValues(alpha: 0.1);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: padding ?? EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: effectiveBgColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[prefixIcon!, SizedBox(width: 8.w)],
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: fontSize ?? 12.sp,
                  fontWeight: FontWeight.w800,
                  color: effectiveTextColor,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
