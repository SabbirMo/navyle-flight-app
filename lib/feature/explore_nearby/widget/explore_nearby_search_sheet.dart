import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/explore_nearby/provider/explore_nearby_notifier.dart';

class ExploreNearbySearchSheet extends ConsumerWidget {
  final VoidCallback? onExploreTap;
  final VoidCallback? onClose;

  const ExploreNearbySearchSheet({super.key, this.onExploreTap, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(exploreNearbyNotifierProvider);
    final notifier = ref.read(exploreNearbyNotifierProvider.notifier);
    final hubs = state.filteredHubs;
    final selectedItem = state.selectedHub;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.textFieldBgColor : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.72.sh),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title
                Text(
                  'Explore Airport Nearby',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Select a destination hub to preview terminal services',
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: isDark
                        ? AppColors.lightGray
                        : const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 14.h),

                // Location Banner
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkBlack : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: isDark
                          ? AppColors.lightBlueGray.withValues(alpha: 0.25)
                          : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF78350F).withValues(alpha: 0.35)
                              : const Color(0xFFFEF3C7),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            state.isLocationEnabled
                                ? Icons.location_on_outlined
                                : Icons.location_off_outlined,
                            size: 15.sp,
                            color: isDark
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD97706),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.isLocationEnabled
                                  ? 'Location on'
                                  : 'Location off',
                              style: GoogleFonts.inter(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.white
                                    : const Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              state.isLocationEnabled
                                  ? 'Showing nearby hubs'
                                  : 'Showing global hubs',
                              style: GoogleFonts.inter(
                                fontSize: 10.5.sp,
                                color: isDark
                                    ? AppColors.lightGray
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          notifier.toggleLocation();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.textFieldBgColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.lightBlueGray.withValues(
                                      alpha: 0.3,
                                    )
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Text(
                            state.isLocationEnabled
                                ? 'Disable'
                                : 'Enable Location',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),

                // POPULAR & RECENT HUBS Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'POPULAR & RECENT HUBS',
                      style: GoogleFonts.inter(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: isDark
                            ? AppColors.lightGray
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBlack
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${hubs.length} Available',
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.lightGray
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Hubs List
                ...hubs.map((hub) {
                  final isSelected = hub.code == state.selectedHubCode;
                  return GestureDetector(
                    onTap: () {
                      notifier.selectHubCode(hub.code);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBlack : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? (isDark
                                  ? AppColors.primaryColor
                                  : const Color(0xFF0F172A))
                              : (isDark
                                  ? AppColors.lightBlueGray.withValues(
                                      alpha: 0.25,
                                    )
                                  : const Color(0xFFE2E8F0)),
                          width: isSelected ? 1.6 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Hub Code Badge
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.primaryColor
                                      : const Color(0xFF0F172A))
                                  : (isDark
                                      ? AppColors.textFieldBgColor
                                      : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hub.code,
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? AppColors.white
                                            : const Color(0xFF1E293B)),
                                  ),
                                ),
                                Text(
                                  'HUB',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: isSelected
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : (isDark
                                            ? AppColors.lightGray
                                            : const Color(0xFF94A3B8)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Title & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        hub.name,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.white
                                              : const Color(0xFF0F172A),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (hub.badge != null) ...[
                                      SizedBox(width: 6.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6.w,
                                          vertical: 2.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.blue2563EB.withValues(
                                                  alpha: 0.2,
                                                )
                                              : (hub.badgeColor ??
                                                  const Color(0xFFEFF6FF)),
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                        child: Text(
                                          hub.badge!,
                                          style: GoogleFonts.inter(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? AppColors.blueShadow
                                                : (hub.badgeTextColor ??
                                                    const Color(0xFF2563EB)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  hub.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    color: isDark
                                        ? AppColors.lightGray
                                        : const Color(0xFF64748B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),

                          // Selection indicator
                          if (isSelected)
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.primaryColor
                                    : const Color(0xFF0F172A),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.lightBlueGray.withValues(
                                          alpha: 0.4,
                                        )
                                      : const Color(0xFFCBD5E1),
                                  width: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(height: 6.h),

                // Bottom Action Button
                GestureDetector(
                  onTap: onExploreTap,
                  child: Container(
                    width: double.infinity,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryColor
                          : AppColors.blackShadow,
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.explore_outlined,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Explore ${selectedItem.name} (${selectedItem.code})',
                          style: GoogleFonts.inter(
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
