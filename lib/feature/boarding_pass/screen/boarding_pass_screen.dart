import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/boarding_pass/provider/boarding_pass_notifier.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/boarding_status_card.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/boarding_timer_card.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/current_gate_card.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/route_update_card.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/show_boarding_pass_button.dart';
import 'package:navyla_flight_app/feature/boarding_pass/widget/stress_free_badge.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class BoardingPassScreen extends ConsumerWidget {
  const BoardingPassScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(boardingPassNotifierProvider);
    final notifier = ref.read(boardingPassNotifierProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.showing),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 12.h),

                          // Top Logo: NAVYLA
                          Image.asset(
                            ImageAssets.navylaWhite,
                            width: 140.w,
                            fit: BoxFit.contain,
                          ),

                          SizedBox(height: 18.h),

                          // 60-Minute Stress-Free Mode Active Pill Badge
                          StressFreeBadge(
                            title: state.stressFreeTitle,
                            isActive: state.isStressFreeModeActive,
                            onTap: notifier.toggleStressFreeMode,
                          ),

                          SizedBox(height: 20.h),

                          // Glassmorphic Countdown Card: BOARDING BEGINS IN 18:42
                          BoardingTimerCard(
                            formattedTime: state.formattedCountdown,
                          ),

                          SizedBox(height: 16.h),

                          // Two Side-by-Side Cards: Current Gate & Boarding Status
                          Row(
                            children: [
                              Expanded(
                                child: CurrentGateCard(
                                  gate: state.gate,
                                  walkTimeMinutes: state.walkTimeMinutes,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: BoardingStatusCard(
                                  status: state.boardingStatus,
                                  subtitle: state.statusSubtitle,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Route Update Alert Card
                          RouteUpdateCard(
                            title: state.routeUpdateTitle,
                            message: state.routeUpdateMessage,
                          ),

                          SizedBox(height: 36.h),

                          // Show Boarding Pass Button -> Navigates directly to Ticket tab
                          ShowBoardingPassButton(
                            onTap: () {
                              ref
                                  .read(navbarNotifierProvider.notifier)
                                  .setIndex(1);
                              context.go(AppRouterName.navbarScreen);
                            },
                          ),

                          SizedBox(height: 18.h),

                          // Exit Stress-Free Mode Button
                          GestureDetector(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go(AppRouterName.navbarScreen);
                              }
                            },
                            child: Text(
                              'EXIT STRESS-FREE MODE',
                              style: GoogleFonts.inter(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),

                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
