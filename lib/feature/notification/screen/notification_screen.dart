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
    final notifications = ref.watch(notificationNotifierProvider);
    final notifier = ref.read(notificationNotifierProvider.notifier);

    // Group notifications by section (preserving insertion order)
    final sections = <String, List<NotificationItem>>{};
    for (final item in notifications) {
      sections.putIfAbsent(item.section, () => []).add(item);
    }

    return CommonScreen(
      child: Column(
        children: [
          // Header with Back Button
          const CustomBackButton(title: "NOTIFICATIONS", isBorder: true),
          SizedBox(height: 12.h),

          // Scrollable Notifications List
          Expanded(
            child: notifications.isEmpty
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
