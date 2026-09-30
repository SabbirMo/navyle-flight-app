import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class SmartWatchRadarBackground extends StatefulWidget {
  final Widget child;
  final bool isAnimating;

  const SmartWatchRadarBackground({
    super.key,
    required this.child,
    this.isAnimating = true,
  });

  @override
  State<SmartWatchRadarBackground> createState() =>
      _SmartWatchRadarBackgroundState();
}

class _SmartWatchRadarBackgroundState extends State<SmartWatchRadarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SmartWatchRadarBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.w,
      height: 220.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Static Concentric Guide Rings
          CustomPaint(size: Size(280.w, 220.h), painter: _StaticRingsPainter()),

          // 2. Rotating Radar Dots and Scanning Arcs
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(280.w, 220.h),
                  painter: _RotatingRadarPainter(),
                ),
              );
            },
          ),

          // 3. Center Watch/Icon (Stationary)
          widget.child,
        ],
      ),
    );
  }
}

class _StaticRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final innerRingPaint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final middleRingPaint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final outerRingPaint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw concentric radar circles
    canvas.drawCircle(center, 54.r, innerRingPaint);
    canvas.drawCircle(center, 78.r, middleRingPaint);
    canvas.drawCircle(center, 104.r, outerRingPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RotatingRadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final dotPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.fill;

    final dotSoftPaint = Paint()
      ..color = AppColors.primaryColor.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    // Rotating Radar Signal Dots at varying orbits (clean dots only, no arc lines)
    // Inner orbit dots (54.r)
    canvas.drawCircle(
      Offset(
        center.dx + 54.r * math.cos(0.8),
        center.dy + 54.r * math.sin(0.8),
      ),
      3.0.r,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(
        center.dx + 54.r * math.cos(-1.8),
        center.dy + 54.r * math.sin(-1.8),
      ),
      2.5.r,
      dotSoftPaint,
    );

    // Middle orbit dots (78.r)
    canvas.drawCircle(
      Offset(
        center.dx + 78.r * math.cos(0.3),
        center.dy + 78.r * math.sin(0.3),
      ),
      3.5.r,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(
        center.dx + 78.r * math.cos(2.2),
        center.dy + 78.r * math.sin(2.2),
      ),
      3.0.r,
      dotSoftPaint,
    );
    canvas.drawCircle(
      Offset(
        center.dx + 78.r * math.cos(-2.0),
        center.dy + 78.r * math.sin(-2.0),
      ),
      3.2.r,
      dotPaint,
    );

    // Outer orbit dots (104.r)
    canvas.drawCircle(
      Offset(
        center.dx + 104.r * math.cos(-0.6),
        center.dy + 104.r * math.sin(-0.6),
      ),
      3.5.r,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(
        center.dx + 104.r * math.cos(1.6),
        center.dy + 104.r * math.sin(1.6),
      ),
      3.0.r,
      dotSoftPaint,
    );
    canvas.drawCircle(
      Offset(
        center.dx + 104.r * math.cos(3.6),
        center.dy + 104.r * math.sin(3.6),
      ),
      3.2.r,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
