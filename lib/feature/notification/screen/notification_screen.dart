import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/notification/model/notification_item.dart';
import 'package:navyla_flight_app/feature/notification/provider/notification_notifier.dart';
import 'package:navyla_flight_app/feature/notification/widget/notification_card.dart';
import 'package:navyla_flight_app/feature/notification/widget/notification_section_header.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final journeyState = ref.watch(flightJourneyNotifierProvider);
    final hasActiveJourney = journeyState.hasActiveFlight;
    final notifications = ref.watch(notificationNotifierProvider);
    final notifier = ref.read(notificationNotifierProvider.notifier);

    // Group notifications by section (preserving insertion order)
    final sections = <String, List<NotificationItem>>{};
    for (final item in notifications) {
      sections.putIfAbsent(item.section, () => []).add(item);
    }

    final hasUnread = hasActiveJourney && notifications.any((n) => n.isUnread);

    return CommonScreen(
      child: Column(
        children: [
          // Header with Back Button & optional Mark all read action
          CustomBackButton(
            title: "NOTIFICATIONS",
            isBorder: true,
            trailing: hasUnread
                ? Tooltip(
                    message: "Mark all as read",
                    child: GestureDetector(
                      onTap: () => notifier.markAllAsRead(),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.white.withValues(alpha: 0.2)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.blackShadow.withValues(
                                alpha: 0.12,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.done_all_rounded,
                            size: 18.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.white
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 12.h),

          // Scrollable Notifications List or No Active Journey
          Expanded(
            child: !hasActiveJourney
                ? _buildNoActiveJourneyState(context)
                : notifications.isEmpty
                ? _buildEmptyState()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final entry in sections.entries) ...[
                          NotificationSectionHeader(
                            title: entry.key,
                            topPadding: 14,
                          ),
                          for (final item in entry.value)
                            NotificationCard(
                              item: item,
                              onTap: () => notifier.markAsRead(item.id),
                            ),
                        ],
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveJourneyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            Text(
              "No active journey",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.white : const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              "Ready for your next trip? Scan or load your boarding pass to receive real-time journey notifications and flight alerts.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 80.h),
        child: Column(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  ImageAssets.notification,
                  width: 28.w,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF94A3B8),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "No Notifications",
              style: StyleManager.sfProBold16(const Color(0xFF1E293B)),
            ),
            SizedBox(height: 6.h),
            Text(
              "You're all caught up with your updates!",
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
