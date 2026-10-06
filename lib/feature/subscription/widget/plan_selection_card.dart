import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class PlanSelectionCard extends StatelessWidget {
  final String planTitle;
  final String price;
  final String period;
  final bool isSelected;
  final String? badgeText;
  final VoidCallback onTap;

  const PlanSelectionCard({
    super.key,
    required this.planTitle,
    required this.price,
    required this.period,
    required this.isSelected,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primaryColor;
    final inactiveBorderColor = const Color(0xFFE2E8F0);

    Widget cardBody = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: isSelected ? activeColor : inactiveBorderColor,
            width: isSelected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  planTitle,
                  style: StyleManager.interBold10(
                    AppColors.lightGray,
                  ).copyWith(fontSize: 11.sp, letterSpacing: 0.9),
                ),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontFamily: 'SF-Pro',
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackShadow,
                      ),
                    ),
                    Text(
                      period,
                      style: StyleManager.interMedium14(AppColors.lightGray),
                    ),
                  ],
                ),
              ],
            ),

            // Radio Button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );

    if (badgeText == null) {
      return cardBody;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        cardBody,
        Positioned(
          top: -10.h,
          right: 32.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.35),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              badgeText!,
              style: TextStyle(
                fontFamily: 'SF-Pro',
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
