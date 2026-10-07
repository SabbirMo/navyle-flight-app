import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/squircke_icon_widget.dart';

class _BlurredModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  _BlurredModalBottomSheetRoute({
    required super.builder,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.backgroundColor,
    super.elevation,
    super.shape,
    super.clipBehavior,
    super.constraints,
    super.modalBarrierColor,
    super.isDismissible = true,
    super.enableDrag = true,
    super.showDragHandle,
    required super.isScrollControlled,
    super.scrollControlDisabledMaxHeightRatio,
    super.settings,
    super.requestFocus,
    super.transitionAnimationController,
    super.anchorPoint,
    super.useSafeArea = false,
    super.sheetAnimationStyle,
  });

  @override
  Widget buildModalBarrier() {
    final barrier = super.buildModalBarrier();
    final anim = animation;
    if (anim != null) {
      return AnimatedBuilder(
        animation: anim,
        builder: (context, child) {
          final blurVal = (4.0 * anim.value).clamp(0.001, 8.0);
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurVal, sigmaY: blurVal),
            child: child,
          );
        },
        child: barrier,
      );
    }
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
      child: barrier,
    );
  }
}

class NotificationBottomSheet extends StatefulWidget {
  final VoidCallback? onEnable;
  final VoidCallback? onSkip;

  const NotificationBottomSheet({super.key, this.onEnable, this.onSkip});

  static Future<T?> show<T>(
    BuildContext context, {
    VoidCallback? onEnable,
    VoidCallback? onSkip,
  }) {
    final NavigatorState navigator = Navigator.of(context);
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );

    return navigator.push(
      _BlurredModalBottomSheetRoute<T>(
        builder: (context) =>
            NotificationBottomSheet(onEnable: onEnable, onSkip: onSkip),
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: navigator.context,
        ),
        isScrollControlled: true,
        barrierLabel: localizations.scrimLabel,
        barrierOnTapHint: localizations.scrimOnTapHint(
          localizations.bottomSheetLabel,
        ),
        backgroundColor: Colors.transparent,
        modalBarrierColor: Colors.black.withValues(alpha: 0.35),
        isDismissible: true,
        enableDrag: true,
      ),
    );
  }

  @override
  State<NotificationBottomSheet> createState() =>
      _NotificationBottomSheetState();
}

class _NotificationBottomSheetState extends State<NotificationBottomSheet>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);

  @override
  void reassemble() {
    super.reassemble();
    _animations.reassemble();
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12.h),

            // Drag handle pill
            Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            SizedBox(height: 16.h),

            // Notification Visual Illustration (Center Bell + 2 floating cards)
            _animations.buttonTransition(
              child: SizedBox(
                height: 146.h,
                width: double.infinity,
                child: Center(
                  child: SizedBox(
                    width: 290.w,
                    height: 146.h,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // 1. Center Blue Squircle with Notification Bell Icon
                        SquircleIcon(icon: Icons.notifications_rounded),

                        // 2. Top-Right Card: GATE CHANGE (Go to B24 now)
                        Positioned(
                          top: 4.h,
                          right: -16.w,
                          child: _gateChangeTimeLeave(
                            title: "GATE CHANGE",
                            subTitle: "Go to B24 now",
                            icon: Icons.flight_takeoff_rounded,
                            iconColor: AppColors.blueColor,
                            cardColor: true,
                            isDark: isDark,
                          ),
                        ),

                        // 3. Bottom-Left Card: TIME TO LEAVE (Walk in 5 mins)
                        Positioned(
                          bottom: 8.h,
                          left: -20.w,
                          child: _gateChangeTimeLeave(
                            title: "TIME TO LEAVE",
                            subTitle: "Walk in 5 mins",
                            icon: Icons.access_time_filled_rounded,
                            iconColor: AppColors.primaryColor,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Title
            _animations.textTransition(
              child: Text(
                AppString.notificationSheetTitle,
                style: StyleManager.sfProBold24(
                  isDark ? AppColors.white : AppColors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            // Description
            _animations.taglineTransition(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  AppString.notificationSheetDesc,
                  style: StyleManager.interMedium12(
                    isDark ? AppColors.lightGray : AppColors.grayColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Note text
            _animations.taglineTransition(
              child: Text(
                AppString.notificationSheetNote,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20.h),

            // Primary Button: Enable Notification
            _animations.buttonTransition(
              child: CustomButton(
                text: AppString.enableNotification,
                borderRadius: 12.r,
                height: 44.h,
                boxShadow: true,
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onEnable?.call();
                },
              ),
            ),

            SizedBox(height: 12.h),

            // Secondary Button: Skip for Now
            _animations.taglineTransition(
              child: InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onSkip?.call();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    AppString.skipForNow,
                    style: StyleManager.interMedium12(
                      isDark ? AppColors.lightGray : AppColors.grayColor,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 6.h),
          ],
        ),
      ),
    );
  }

  Widget _gateChangeTimeLeave({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color iconColor,
    bool cardColor = false,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.white : AppColors.lightBgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? AppColors.white
              : AppColors.primaryColor.withValues(alpha: isDark ? 0.4 : 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: cardColor
                  ? AppColors.blueShadow.withValues(alpha: isDark ? 0.2 : 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: 16.sp),
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.blackShadow : AppColors.blackShadow,
                  letterSpacing: 0.3,
                ),
              ),

              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: isDark ? AppColors.lightBlueGray : AppColors.grayColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
