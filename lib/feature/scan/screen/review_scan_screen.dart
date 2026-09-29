import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/provider/scan_camera_notifier.dart';
import 'package:navyla_flight_app/feature/scan/widget/scanner_corner_overlay.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ReviewScanScreen extends ConsumerWidget {
  final String? imagePath;

  const ReviewScanScreen({super.key, this.imagePath});

  void _handleUseScan(BuildContext context) {
    context.push(AppRouterName.verifyDetailsScreen);
  }

  void _handleRetake(BuildContext context, WidgetRef ref) {
    ref.read(scanCameraNotifierProvider.notifier).retake();
    context.pop();
  }

  Widget _buildImagePreview(String? path) {
    if (path != null && path.isNotEmpty) {
      if (kIsWeb) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Image.asset(ImageAssets.scanPassPreview, fit: BoxFit.cover),
        );
      }
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset(ImageAssets.scanPassPreview, fit: BoxFit.cover),
      );
    }

    return Image.asset(ImageAssets.scanPassPreview, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanCameraNotifierProvider);
    final currentImagePath = imagePath ?? scanState.capturedImage?.path;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageAssets.scanCameraBg),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(57, 252, 224, 199),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),
                  // Header Back button with centered title
                  const CustomBackButton(title: 'Review Scan'),
                  SizedBox(height: 16.h),

                  // Boarding Pass small category label
                  Text(
                    'Boarding Pass',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Main heading
                  Text(
                    'Check your scan',
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    'Make sure your boarding pass is clear and readable before we extract the details.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grayColor,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Captured Photo Frame with Orange Corner Overlays
                  Container(
                    width: double.infinity,
                    height: 220.h,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: _buildImagePreview(currentImagePath),
                          ),
                        ),
                        const Positioned.fill(
                          child: ScannerCornerOverlay(
                            cornerLength: 36,
                            strokeWidth: 4.5,
                            radius: 24,
                            color: Color(0xFFFA7E23),
                            outlineColor: Color(0x3FFA7E23),
                            outlineWidth: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // Prompt question card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Is this scan clear and complete?',
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'If anything is blurry or missing, retake the photo.',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Use This Scan primary button
                  CustomButton(
                    text: 'Use This Scan',
                    onTap: () => _handleUseScan(context),
                  ),
                  SizedBox(height: 12.h),

                  // Retake secondary button
                  CustomButton(
                    text: "Retake",
                    bgColor: AppColors.white,
                    isBg: true,
                    onTap: () => _handleRetake(context, ref),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
