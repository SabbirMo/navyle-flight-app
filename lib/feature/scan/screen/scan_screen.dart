import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/widget/scan_camera_card.dart';
import 'package:navyla_flight_app/feature/scan/widget/scan_option_card.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  void _handleCameraScan(BuildContext context) {
    context.push(AppRouterName.scanCameraScreen);
  }

  static bool _isPickingImage = false;

  Future<void> _handleGalleryPick(BuildContext context) async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && context.mounted) {
        context.push(AppRouterName.reviewScanScreen, extra: pickedFile.path);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    } finally {
      _isPickingImage = false;
    }
  }

  void _handleManualEntry(BuildContext context) {
    context.push(AppRouterName.verifyDetailsScreen, extra: {'isManual': true});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark ? ImageAssets.darkScan : ImageAssets.scanBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Back button at top left
                  const Align(
                    alignment: Alignment.topLeft,
                    child: CustomBackButton(isBorder: true),
                  ),
                  SizedBox(height: 40.h),

                  // Logo and warm shadow
                  Image.asset(ImageAssets.appLogo, width: 120.w),
                  Transform.translate(
                    offset: Offset(0, -6.h),
                    child: Image.asset(
                      ImageAssets.effect,
                      width: 135.w,
                      color: const Color(0xFFFA7E23),
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // Heading
                  Text(
                    "Load your ticket",
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle
                  Text(
                    "Upload your digital pass or scan a printed one\nto begin your stress-free journey.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark
                          ? AppColors.grayD3D3D3.withValues(alpha: 0.9)
                          : const Color(0xFF64748B),
                      height: 1.45,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Big Camera Card
                  ScanCameraCard(onTap: () => _handleCameraScan(context)),

                  SizedBox(height: 16.h),

                  // Bottom Two Action Cards (Gallery & Manual entry)
                  Row(
                    children: [
                      Expanded(
                        child: ScanOptionCard(
                          title: "Gallery",
                          icon: Icons.image_outlined,
                          onTap: () => _handleGalleryPick(context),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: ScanOptionCard(
                          title: "Manual entry",
                          icon: Icons.keyboard_outlined,
                          onTap: () => _handleManualEntry(context),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
