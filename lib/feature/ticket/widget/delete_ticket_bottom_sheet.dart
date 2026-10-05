import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class DeleteTicketBottomSheet extends StatelessWidget {
  final String flightNumber;
  final String originCode;
  final String destinationCode;
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteTicketBottomSheet({
    super.key,
    required this.flightNumber,
    required this.originCode,
    required this.destinationCode,
    required this.onDelete,
    required this.onCancel,
  });

  static Future<void> show(
    BuildContext context, {
    required String flightNumber,
    required String originCode,
    required String destinationCode,
    required VoidCallback onDelete,
    VoidCallback? onCancel,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(ctx).pop();
            onCancel?.call();
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.18),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap:
                        () {}, // Prevent taps inside bottom sheet from dismissing
                    child: DeleteTicketBottomSheet(
                      flightNumber: flightNumber,
                      originCode: originCode,
                      destinationCode: destinationCode,
                      onDelete: () {
                        Navigator.of(ctx).pop();
                        onDelete();
                      },
                      onCancel: () {
                        Navigator.of(ctx).pop();
                        onCancel?.call();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flightText =
        'British Airways flight ${flightNumber.isNotEmpty ? flightNumber : "BA 0215"} (${originCode.isNotEmpty ? originCode : "AMS"} → ${destinationCode.isNotEmpty ? destinationCode : "FRA"})';

    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        margin: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              width: 38.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 18.h),

            // Delete Icon Badge
            Container(
              width: 58.w,
              height: 58.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFECEB),
                border: Border.all(
                  color: AppColors.errorRed.withValues(alpha: 0.2),
                  width: 4,
                ),
              ),
              child: Center(
                child: Icon(Icons.delete_outline, color: AppColors.errorRed),
              ),
            ),
            SizedBox(height: 16.h),

            // Title
            Text(
              'Delete Boarding Pass?',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E293B),
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 10.h),

            // Description
            Text.rich(
              TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 12.5.sp,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
                children: [
                  const TextSpan(text: 'This will remove '),
                  TextSpan(
                    text: flightText,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const TextSpan(
                    text:
                        ' from your active journey. You can re-import it anytime by scanning your boarding pass again.',
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Delete Button (Red)
            DeleteSheetButton(
              title: 'Delete Ticket',
              onTap: onDelete,
              backgroundColor: const Color(0xFFFF3838),
              textColor: Colors.white,
              borderRadius: 16.r,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3838).withValues(alpha: 0.32),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // Keep Ticket Button (Light Gray)
            DeleteSheetButton(
              title: 'Keep Ticket',
              onTap: onCancel,
              backgroundColor: const Color(0xFFE2E8F0),
              textColor: const Color(0xFF475569),
              borderRadius: 16.r,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteSheetButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final double? height;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;

  const DeleteSheetButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.height,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height ?? 44.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
