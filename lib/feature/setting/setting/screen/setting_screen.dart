import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/theme/theme_mode_provder.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/profile_details_card.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/setting_item_tile.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/setting_toggle_switch.dart';
import 'package:navyla_flight_app/feature/setting/setting/widget/subscription_plan_card.dart';
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
            const CustomBackButton(title: "SETTINGS"),
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
                        // Handle manage plan
                      },
                    ),
                    SizedBox(height: 18.h),

                    // 3. Appearance
                    _buildSectionTitle("APPEARANCE"),
                    SettingCardContainer(
                      children: [
                        SettingItemTile(
                          iconWidget: const SettingIconBox(
                            icon: Icons.nightlight_round,
                            backgroundColor: Color(0xFFFFF3E6),
                            iconColor: Color(0xFFFF942B),
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
                          iconWidget: const SettingIconBox(
                            icon: Icons.watch_rounded,
                            backgroundColor: Color(0xFFFFF1E6),
                            iconColor: Color(0xFFFF8533),
                          ),
                          title: "Watch Sync",
                          subtitle: "Searching for Devices",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14.sp,
                            color: const Color(0xFF94A3B8),
                          ),
                          onTap: () {
                            // Handle watch sync
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: const SettingIconBox(
                            icon: Icons.location_on_rounded,
                            backgroundColor: Color(0xFFEFF6FF),
                            iconColor: Color(0xFF3B82F6),
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
                          iconWidget: const SettingIconBox(
                            icon: Icons.notifications_rounded,
                            backgroundColor: Color(0xFFFFF3E6),
                            iconColor: Color(0xFFFF8533),
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
                          iconWidget: const SettingIconBox(
                            icon: Icons.star_rounded,
                            backgroundColor: AppColors.warningColor,
                            iconColor: Color(0xFFEAB308),
                          ),
                          title: "RATE NAVYLA",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            // Handle rate navyla
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: const SettingIconBox(
                            icon: Icons.share_rounded,
                            backgroundColor: Color(0xFFEFF6FF),
                            iconColor: Color(0xFF2563EB),
                          ),
                          title: "SHARE NAVYLA",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            // Handle share navyla
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: const SettingIconBox(
                            icon: Icons.description_rounded,
                            backgroundColor: Color(0xFFF1F5F9),
                            iconColor: Color(0xFF64748B),
                          ),
                          title: "TERMS OF SERVICE",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            // Handle terms of service
                          },
                          showDivider: true,
                        ),
                        SettingItemTile(
                          iconWidget: const SettingIconBox(
                            icon: Icons.security_rounded,
                            backgroundColor: Color(0xFFF1F5F9),
                            iconColor: Color(0xFF64748B),
                          ),
                          title: "PRIVACY POLICY",
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13.sp,
                            color: const Color(0xFFCBD5E1),
                          ),
                          onTap: () {
                            // Handle privacy policy
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),

                    // 6. Sign Out Account Button
                    GestureDetector(
                      onTap: () {
                        // Handle sign out
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Color(0xFFEF4444).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        child: Center(
                          child: Text(
                            "SIGN OUT ACCOUNT",
                            style: TextStyle(
                              fontFamily: 'SF-Pro',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFEF4444),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
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
