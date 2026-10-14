import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class FeedHeaderWidget extends StatelessWidget {
  final VoidCallback onAddPostTap;
  final VoidCallback? onBackTap;
  final bool showAddButton;

  const FeedHeaderWidget({
    super.key,
    required this.onAddPostTap,
    this.onBackTap,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 38.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left: Back to Home Arrow Button
            if (onBackTap != null)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  key: const Key('feed_back_button'),
                  onTap: onBackTap,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.lightGray.withValues(alpha: 0.2)
                          : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark ? AppColors.white : AppColors.blackShadow,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),

            // Center: NAVYLA Logo + "FEED" Title (centered in header)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Image.asset(
                      isDark ? ImageAssets.navylaWhite : ImageAssets.navyla,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'FEED',
                    style: StyleManager.sfProBold16(
                      isDark ? AppColors.white : AppColors.feedColor,
                    ).copyWith(fontSize: 18.sp),
                  ),
                ],
              ),
            ),

            // Right: Orange '+' Button
            if (showAddButton)
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onAddPostTap,
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.38),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 26.sp,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
