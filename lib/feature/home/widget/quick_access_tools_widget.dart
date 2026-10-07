import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/home/model/quick_access_tool_model.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

/// A 2x2 Grid section displaying the 4 Quick Access Tool cards:
/// - Airport Navigation
/// - Boarding pass
/// - Explore nearby
/// - Ask NAVYLA
class QuickAccessToolsWidget extends ConsumerWidget {
  final List<QuickAccessToolModel>? tools;
  final VoidCallback? onAskNavylaTap;
  final VoidCallback? onBoardingPassTap;
  final VoidCallback? onExploreNearbyTap;

  const QuickAccessToolsWidget({
    super.key,
    this.tools,
    this.onAskNavylaTap,
    this.onBoardingPassTap,
    this.onExploreNearbyTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = tools ?? QuickAccessToolModel.defaultTools;

    if (list.length < 4) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Row 1: Airport Navigation & Boarding Pass
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                item: list[0],
                onTap: () => context.push(AppRouterName.navigateAirportRoute),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _QuickAccessCard(
                item: list[1],
                onTap:
                    onBoardingPassTap ??
                    () => ref.read(navbarNotifierProvider.notifier).setIndex(1),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        // Row 2: Explore Nearby & Ask NAVYLA
        Row(
          children: [
            Expanded(
              child: _QuickAccessCard(
                item: list[2],
                onTap:
                    onExploreNearbyTap ??
                    () {
                      final hasBoardingPass = ref
                          .read(flightJourneyNotifierProvider)
                          .hasActiveFlight;
                      if (hasBoardingPass) {
                        context.push(AppRouterName.navigateAirportRoute);
                      } else {
                        context.push(AppRouterName.exploreNearbyScreen);
                      }
                    },
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: _QuickAccessCard(
                item: list[3],
                onTap:
                    onAskNavylaTap ??
                    () => context.push(AppRouterName.aiChatScreen),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final QuickAccessToolModel item;
  final VoidCallback? onTap;

  const _QuickAccessCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 94.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(item.bgImage),
            fit: BoxFit.fill,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Optional overlay illustration (e.g. Robot mascot for Ask NAVYLA)
            if (item.overlayWidget != null) item.overlayWidget!,

            // Top-left Icon Box
            Positioned(
              top: 13.h,
              left: 13.w,
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: item.iconWidget,
              ),
            ),

            // Bottom-left Text (Title & Subtitle)
            Positioned(
              left: 13.w,
              bottom: 13.h,
              right: 36.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      letterSpacing: -0.2,
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightBlueGray,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bottom-right Action Chevron (always on right side)
            Positioned(
              right: 13.w,
              bottom: 13.h,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13.sp,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
