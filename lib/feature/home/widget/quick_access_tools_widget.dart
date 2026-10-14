import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/explore_nearby/model/explore_nearby_state.dart';
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
                      final journey = ref.read(flightJourneyNotifierProvider);
                      if (journey.hasActiveFlight) {
                        final hubs = const ExploreNearbyState().allHubs;
                        final originCode = journey.originCode ?? 'AMS';
                        final hub = hubs.firstWhere(
                          (h) =>
                              h.code.toUpperCase() == originCode.toUpperCase(),
                          orElse: () => AirportHubItem(
                            code: originCode,
                            name:
                                journey.originCity != null &&
                                    journey.originCity!.isNotEmpty
                                ? journey.originCity!
                                : originCode,
                            subtitle:
                                '${journey.originCity ?? originCode} • Terminal ${journey.terminal ?? '1'}',
                          ),
                        );
                        context.push(
                          AppRouterName.exploreHubDetailsScreen,
                          extra: hub,
                        );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgImage = (isDark && item.darkBgImage != null)
        ? item.darkBgImage!
        : item.bgImage;
    final icon = (isDark && item.darkIconWidget != null)
        ? item.darkIconWidget!
        : item.iconWidget;
    final overlay = isDark
        ? (item.darkOverlayWidget ?? item.overlayWidget)
        : item.overlayWidget;

    return GestureDetector(
      onTap: onTap ?? item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: isDark ? 104.h : 94.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isDark ? 22.r : 16.r),
          border: isDark
              ? Border.all(
                  color: const Color(0xFFC07028).withValues(alpha: 0.75),
                  width: 1.2,
                )
              : Border.all(
                  color: AppColors.lightGray.withValues(alpha: 0.5),
                  width: 1.2,
                ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? AppColors.primaryColor.withValues(alpha: 0.5)
                  : AppColors.lightGray.withValues(alpha: 0.9),
              blurRadius: isDark ? 6 : 10,
              offset: const Offset(4, 4),
            ),
          ],
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: isDark ? BoxFit.cover : BoxFit.fill,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Optional overlay illustration (e.g. Robot mascot for Ask NAVYLA)
            ?overlay,

            // Top-left Icon Box
            Positioned(
              top: isDark ? 12.h : 13.h,
              left: isDark ? 12.w : 13.w,
              child: Container(
                width: isDark ? 40.w : 36.w,
                height: isDark ? 40.w : 36.w,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.18)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(isDark ? 14.r : 10.r),
                  border: isDark
                      ? Border.all(
                          color: const Color(
                            0xFFC07028,
                          ).withValues(alpha: 0.75),
                          width: 1.1,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.06,
                      ),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: icon,
              ),
            ),

            // Bottom-left Text (Title & Subtitle)
            Positioned(
              left: isDark ? 12.w : 13.w,
              bottom: isDark ? 12.h : 13.h,
              right: 32.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.grayD3D3D3 : AppColors.black,
                      letterSpacing: -0.2,
                      height: 1.15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isDark ? 4.h : 3.h),
                  Text(
                    item.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? const Color(0xFFFDB561)
                          : AppColors.lightBlueGray,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Bottom-right Action Chevron
            Positioned(
              right: isDark ? 8.w : 13.w,
              bottom: isDark ? 10.h : 13.h,
              child: Icon(
                isDark
                    ? Icons.chevron_right_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: isDark ? 22.sp : 13.sp,
                color: isDark ? const Color(0xFFF59E0B) : AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
