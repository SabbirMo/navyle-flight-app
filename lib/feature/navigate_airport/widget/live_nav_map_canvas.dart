import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class LiveNavMapCanvas extends StatelessWidget {
  final TransformationController transformationController;

  const LiveNavMapCanvas({
    super.key,
    required this.transformationController,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      minScale: 0.8,
      maxScale: 2.5,
      boundaryMargin: const EdgeInsets.all(80),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // 1. Map Base Background
                Container(
                  width: width,
                  height: height,
                  color: const Color(0xFFE7ECEF),
                ),

                // 2. Horizontal Blue River / Corridor Band
                Positioned(
                  top: height * 0.33,
                  left: 0,
                  right: 0,
                  height: 72.h,
                  child: Container(
                    color: const Color(0xFFBAE6FD),
                  ),
                ),

                // 3. Central Vertical White Road
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: (width / 2) - 16.w,
                  width: 32.w,
                  child: Container(
                    color: Colors.white,
                  ),
                ),

                // 4. Central Dotted Orange Navigation Path
                Positioned(
                  top: 90.h,
                  bottom: height * 0.31,
                  left: (width / 2) - 6.w,
                  width: 12.w,
                  child: CustomPaint(
                    painter: _DottedLinePainter(
                      color: AppColors.primaryColor,
                      dotRadius: 3.5.r,
                      spacing: 16.h,
                    ),
                  ),
                ),

                // 5. Horizontal Dotted Path segment turning out from Bank Asia
                Positioned(
                  top: height * 0.635,
                  left: (width / 2) - 38.w,
                  width: 36.w,
                  height: 12.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDot(),
                      _buildDot(),
                      _buildDot(),
                    ],
                  ),
                ),

                // 6. Buildings / Landmarks
                // Top Left building (blank)
                Positioned(
                  top: height * 0.22,
                  left: 45.w,
                  width: 105.w,
                  height: 60.h,
                  child: _buildBuildingCard(),
                ),

                // Top Right building (Kaderia Tower)
                Positioned(
                  top: height * 0.215,
                  right: 25.w,
                  width: 155.w,
                  height: 68.h,
                  child: _buildBuildingCard(
                    title: 'Kaderia Tower',
                  ),
                ),

                // Middle Left building (Masjid-e-Gausul Azam)
                Positioned(
                  top: height * 0.46,
                  left: 60.w,
                  width: 118.w,
                  height: 98.h,
                  child: _buildBuildingCard(
                    title: 'Masjid-e-Gausul\nAzam',
                  ),
                ),

                // Middle Right building (blank)
                Positioned(
                  top: height * 0.46,
                  right: 55.w,
                  width: 112.w,
                  height: 110.h,
                  child: _buildBuildingCard(),
                ),

                // Bottom Left building (Bank Asia Limited)
                Positioned(
                  top: height * 0.635,
                  left: 60.w,
                  width: 104.w,
                  height: 80.h,
                  child: _buildBuildingCard(
                    title: 'Bank Asia Limited',
                    titleColor: const Color(0xFF1D4ED8),
                  ),
                ),

                // 7. Starting Position GPS Marker & "3 min slower" badge
                Positioned(
                  top: height * 0.68,
                  left: (width / 2) - 86.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Circular Blue Glow & Orange Nav Arrow
                      Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFDBEAFE).withValues(alpha: 0.8),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF93C5FD).withValues(alpha: 0.6),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.near_me_rounded,
                            size: 22.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // "3 min slower" chip badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.directions_walk_rounded,
                              size: 14.sp,
                              color: const Color(0xFF475569),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '3 min slower',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF334155),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildDot() {
    return Container(
      width: 7.r,
      height: 7.r,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget _buildBuildingCard({
    String? title,
    Color titleColor = const Color(0xFF334155),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.w),
      child: title != null
          ? Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w600,
                color: titleColor,
                height: 1.25,
              ),
            )
          : null,
    );
  }
}

class _DottedLinePainter extends CustomPainter {
  final Color color;
  final double dotRadius;
  final double spacing;

  _DottedLinePainter({
    required this.color,
    required this.dotRadius,
    required this.spacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double y = 0;
    while (y < size.height) {
      canvas.drawCircle(Offset(size.width / 2, y), dotRadius, paint);
      y += spacing;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.spacing != spacing;
  }
}
