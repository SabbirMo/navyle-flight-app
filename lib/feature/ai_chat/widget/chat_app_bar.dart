import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class ChatAppBar extends StatelessWidget {
  final VoidCallback? onInfoTap;

  const ChatAppBar({super.key, this.onInfoTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Squircle Back Button
          GestureDetector(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.sp,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          // Center: Mascot Avatar + "ASK NAVYLA"
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageAssets.navylaAi,
                width: 36.w,
                height: 36.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.w),
              Text(
                'ASK NAVYLA',
                style: TextStyle(
                  fontFamily: 'SF-Pro',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),

          // Right: Info Circle Button
          GestureDetector(
            onTap: onInfoTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
                ),
              ),
              child: Center(
                child: Text(
                  '!',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
