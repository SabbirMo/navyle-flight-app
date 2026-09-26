import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/feed/provider/feed_notifier.dart';

class FeedTabsWidget extends StatelessWidget {
  final FeedTab selectedTab;
  final ValueChanged<FeedTab> onTabChanged;

  const FeedTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              // Feed Tab
              _TabItem(
                title: 'Feed',
                isSelected: selectedTab == FeedTab.feed,
                onTap: () => onTabChanged(FeedTab.feed),
              ),

              // My Post Tab
              _TabItem(
                title: 'My post',
                isSelected: selectedTab == FeedTab.myPost,
                onTap: () => onTabChanged(FeedTab.myPost),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.blackShadow
                      : AppColors.lightGray,
                ),
              ),
            ),
            // Orange indicator line or transparent placeholder
            Container(
              height: 2.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            // Subtle baseline divider
            Container(
              height: 1.h,
              color: isSelected ? Colors.transparent : const Color(0xFFF1F5F9),
            ),
          ],
        ),
      ),
    );
  }
}
