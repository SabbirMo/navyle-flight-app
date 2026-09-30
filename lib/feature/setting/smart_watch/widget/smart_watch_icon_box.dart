import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmartWatchIconBox extends StatelessWidget {
  final double? boxSize;
  final double? iconSize;

  const SmartWatchIconBox({super.key, this.boxSize, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final double actualBoxSize = boxSize ?? 66.w;
    final double actualIconSize = iconSize ?? 28.sp;

    return Container(
      width: actualBoxSize,
      height: actualBoxSize,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFA654), Color(0xFFFF7E1D)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8533).withValues(alpha: 0.35),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(child: _SmartWatchCustomIcon(size: actualIconSize)),
    );
  }
}

/// Custom clean minimalist smartwatch icon representation
class _SmartWatchCustomIcon extends StatelessWidget {
  final double size;
  const _SmartWatchCustomIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size * 0.85, size), painter: _WatchPainter());
  }
}

class _WatchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Top strap
    final topStrapRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.44, h * 0.12),
        width: w * 0.42,
        height: h * 0.22,
      ),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(topStrapRect, whitePaint);

    // Bottom strap
    final bottomStrapRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.44, h * 0.88),
        width: w * 0.42,
        height: h * 0.22,
      ),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(bottomStrapRect, whitePaint);

    // Watch Body (rounded rect)
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.44, h * 0.5),
        width: w * 0.72,
        height: h * 0.65,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(bodyRect, whitePaint);

    // Digital Crown button on the right
    final crownRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.88, h * 0.46),
        width: w * 0.12,
        height: h * 0.22,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(crownRect, whitePaint);

    // Inner watch face outline (transparent/contrast)
    final screenCutoutPaint = Paint()
      ..color = const Color(0xFFFF8533)
      ..style = PaintingStyle.fill;

    final screenRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.44, h * 0.5),
        width: w * 0.52,
        height: h * 0.46,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(screenRect, screenCutoutPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
