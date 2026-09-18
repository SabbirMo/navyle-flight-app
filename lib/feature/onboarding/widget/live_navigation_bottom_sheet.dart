import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/start_animation.dart';
import 'package:navyla_flight_app/feature/onboarding/provider/location_provider.dart';
import 'package:navyla_flight_app/feature/onboarding/widget/squircke_icon_widget.dart';

class LiveNavigationBottomSheet extends ConsumerStatefulWidget {
  final VoidCallback? onAllow;
  final VoidCallback? onNotNow;

  const LiveNavigationBottomSheet({super.key, this.onAllow, this.onNotNow});

  static Future<T?> show<T>(
    BuildContext context, {
    VoidCallback? onAllow,
    VoidCallback? onNotNow,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) =>
          LiveNavigationBottomSheet(onAllow: onAllow, onNotNow: onNotNow),
    );
  }

  @override
  ConsumerState<LiveNavigationBottomSheet> createState() =>
      _LiveNavigationBottomSheetState();
}

class _LiveNavigationBottomSheetState
    extends ConsumerState<LiveNavigationBottomSheet>
    with TickerProviderStateMixin {
  late final StartAnimations _animations = StartAnimations(this);
  bool _isLoading = false;

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

  Future<void> _handleAllowLocation() async {
    setState(() => _isLoading = true);

    try {
      final success = await ref
          .read(liveLocationProvider.notifier)
          .startTracking(context);
      if (success && mounted) {
        Navigator.of(context).pop();
        widget.onAllow?.call();
      }
    } catch (e) {
      debugPrint('⚠️ [NAVAYLA Location] Error requesting location: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            SizedBox(height: 36.h),

            // Location Target Icon with glow
            _animations.buttonTransition(
              child: SquircleIcon(icon: Icons.my_location_rounded),
            ),

            SizedBox(height: 40.h),

            // Title
            _animations.textTransition(
              child: Text(
                AppString.enableLiveNavigationTitle,
                style: StyleManager.sfProBold24(AppColors.black),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 12.h),

            // Description
            _animations.taglineTransition(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  AppString.enableLiveNavigationDesc,
                  style: StyleManager.interMedium12(AppColors.grayColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // Note text
            _animations.taglineTransition(
              child: Text(
                AppString.enableLiveNavigationNote,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 28.h),

            // Primary Button: Allow While Using App
            _animations.buttonTransition(
              child: CustomButton(
                text: "Allow While Using App",
                borderRadius: 12.r,
                height: 44.h,
                boxShadow: true,
                isLoading: _isLoading,
                onTap: _isLoading ? null : _handleAllowLocation,
              ),
            ),

            SizedBox(height: 14.h),

            // Secondary Button: Not Now
            _animations.taglineTransition(
              child: InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {
                  Navigator.of(context).pop();
                  widget.onNotNow?.call();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Text(
                    AppString.notNow,
                    style: StyleManager.interMedium14(
                      AppColors.shadowColor,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Privacy First Badge
            _animations.taglineTransition(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_moon_sharp,
                    size: 13.sp,
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    AppString.privacyBadgeText,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.shadowColor,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}
