import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/model/scan_camera_state.dart';
import 'package:navyla_flight_app/feature/scan/provider/scan_camera_notifier.dart';
import 'package:navyla_flight_app/feature/scan/widget/scanner_corner_overlay.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class ScanCameraScreen extends ConsumerWidget {
  const ScanCameraScreen({super.key});

  void _handleManualEntry(BuildContext context) {
    context.push(AppRouterName.verifyDetailsScreen, extra: {'isManual': true});
  }

  Widget _buildCameraContent(ScanCameraState state) {
    // 1. If live camera is running, show live CameraPreview
    if (state.isCameraInitialized &&
        state.cameraController != null &&
        state.cameraController!.value.isInitialized) {
      final previewSize = state.cameraController!.value.previewSize;
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize?.height ?? 1,
            height: previewSize?.width ?? 1,
            child: CameraPreview(state.cameraController!),
          ),
        ),
      );
    }

    // 2. Clean dark viewfinder while camera initializes — no dummy picture!
    return Container(
      color: Colors.black,
      child: Center(
        child: SizedBox(
          width: 32.w,
          height: 32.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFFFA7E23),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanCameraNotifierProvider);
    final notifier = ref.read(scanCameraNotifierProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark ? ImageAssets.darkShowC : ImageAssets.scanCameraBg,
            ),
            fit: BoxFit.cover,
            colorFilter: isDark
                ? null
                : ColorFilter.mode(
                    Color.fromARGB(57, 252, 224, 199),
                    BlendMode.srcOver,
                  ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // Top header with Back button & NAVYLA logo
                const CustomBackButton(
                  image: ImageAssets.navylaWhite,
                  isImage: true,
                  isBorder: true,
                ),
                SizedBox(height: 8.h),

                // SCAN PASS subtitle
                Text(
                  'SCAN PASS',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2.5,
                    color: isDark ? AppColors.white : const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 14.h),

                // Camera Live Viewfinder Frame with Orange Corner Overlays
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 290.h,
                        decoration: BoxDecoration(
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
                            // Live Camera View
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24.r),
                                child: _buildCameraContent(state),
                              ),
                            ),

                            // Orange Corner Brackets Overlay
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

                      // Instructions
                      Text(
                        'Align the boarding pass',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Keep it within the frame and avoid glare for better extraction.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.lightGray : AppColors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Shutter / Capture Button ("click" button)
                      GestureDetector(
                        onTap: () async {
                          final picture = await notifier.captureImage();
                          if (picture != null && context.mounted) {
                            context.push(
                              AppRouterName.reviewScanScreen,
                              extra: picture.path,
                            );
                          }
                        },
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffEFECE9),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 4.w,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFA7E23,
                                ).withValues(alpha: 0.28),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: state.isCapturing
                                ? SizedBox(
                                    width: 28.w,
                                    height: 28.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: AppColors.primaryColor,
                                    ),
                                  )
                                : Container(
                                    width: 52.w,
                                    height: 52.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // Bottom actions: Gallery & Manual
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Gallery button
                            scanPassWidget(
                              context: context,
                              onTap: () async {
                                final picked = await notifier
                                    .pickGalleryImage();
                                if (picked != null && context.mounted) {
                                  context.push(
                                    AppRouterName.reviewScanScreen,
                                    extra: picked.path,
                                  );
                                }
                              },
                              icon: Icons.image_rounded,
                              title: 'GALLERY',
                            ),

                            // Manual button
                            scanPassWidget(
                              context: context,
                              onTap: () => _handleManualEntry(context),
                              icon: Icons.keyboard_alt_outlined,
                              title: 'MANUAL',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scanPassWidget({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.white.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: const Color(0xFF00559F).withValues(alpha: 0.6),
                width: 1.2,
              ),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 22.sp,
                color: isDark ? AppColors.white : const Color(0xFF1E293B),
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: StyleManager.interBold10(
              isDark ? AppColors.white : AppColors.black,
            ).copyWith(letterSpacing: 0.6),
          ),
        ],
      ),
    );
  }
}
