import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/subscription/model/subscription_billing_cycle.dart';
import 'package:navyla_flight_app/feature/subscription/widget/plan_selection_card.dart';
import 'package:navyla_flight_app/feature/subscription/widget/subscription_feature_tile.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionBillingCycle _selectedCycle = SubscriptionBillingCycle.yearly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CommonScreen(
        child: Column(
          children: [
            // Top Bar: Close Button (X) on Top Right
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close_rounded,
                      size: 18.sp,
                      color: AppColors.lightGray,
                    ),
                  ),
                ),
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: 6.h),

                    // Glowing Crown Circle Badge
                    Center(
                      child: Container(
                        width: 76.w,
                        height: 76.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(
                                alpha: 0.38,
                              ),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageAssets.king,
                            width: 32.w,
                            height: 28.h,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Title & Subtitle
                    Text(
                      "NAVAYLA PLUS",
                      style: StyleManager.sfProBold24(
                        AppColors.black,
                      ).copyWith(fontSize: 26.sp, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Unlock the ultimate stress-free travel experience with real-time intelligence.",
                      textAlign: TextAlign.center,
                      style: StyleManager.interMedium12(
                        AppColors.lightBlueGray,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // 3 Feature Highlights
                    SubscriptionFeatureTile(
                      icon: Icon(
                        Icons.map_rounded,
                        size: 20.sp,
                        color: const Color(0xFF2563EB),
                      ),
                      iconBgColor: const Color(0xFFEFF6FF),
                      title: "Interactive Terminal Maps",
                      subtitle: "Live indoor navigation to your exact gate.",
                    ),
                    SubscriptionFeatureTile(
                      icon: Icon(
                        Icons.notifications_active_rounded,
                        size: 20.sp,
                        color: const Color(0xFF9333EA),
                      ),
                      iconBgColor: const Color(0xFFFAF5FF),
                      title: "Priority Feed Alerts",
                      subtitle:
                          "Get gate change updates 5 mins before the board.",
                    ),
                    SubscriptionFeatureTile(
                      icon: Icon(
                        Icons.history_rounded,
                        size: 20.sp,
                        color: const Color(0xFF10B981),
                      ),
                      iconBgColor: const Color(0xFFECFDF5),
                      title: "Historical Queue Data",
                      subtitle: "Predict security wait times based on trends.",
                    ),
                    SizedBox(height: 18.h),

                    // Monthly Plan Card
                    PlanSelectionCard(
                      planTitle: "MONTHLY",
                      price: "\$4.99",
                      period: "/mo",
                      isSelected:
                          _selectedCycle == SubscriptionBillingCycle.monthly,
                      onTap: () {
                        setState(() {
                          _selectedCycle = SubscriptionBillingCycle.monthly;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Yearly Plan Card with Best Value Badge
                    PlanSelectionCard(
                      planTitle: "YEARLY",
                      price: "\$34.99",
                      period: "/yr",
                      badgeText: "BEST VALUE • SAVE 40%",
                      isSelected:
                          _selectedCycle == SubscriptionBillingCycle.yearly,
                      onTap: () {
                        setState(() {
                          _selectedCycle = SubscriptionBillingCycle.yearly;
                        });
                      },
                    ),
                    SizedBox(height: 22.h),

                    // Risk-Free Trial text
                    Text(
                      "RISK-FREE TRIAL",
                      style: StyleManager.interSemiBold12(
                        AppColors.lightGray,
                      ).copyWith(letterSpacing: 1, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Try all features free for 7 days. Cancel anytime.",
                      style: StyleManager.interMedium12(
                        Color(0xff475569),
                      ).copyWith(letterSpacing: 0.4),
                    ),
                    SizedBox(height: 20.h),

                    // Start 7-Day Free Trial Button
                    CustomButton(
                      text: "START 7-DAY FREE TRIAL",
                      height: 42.h,
                      boxShadow: true,
                    ),
                    SizedBox(height: 20.h),

                    // Footer Terms / Privacy disclaimer
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "By continuing, you agree to NAVAYLA's Terms of Service and Privacy Policy. Subscription renews automatically.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFA4A4A4),
                          height: 1.45,
                        ),
                      ),
                    ),
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
}
