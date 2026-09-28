import 'package:flutter/material.dart';

class ScannerCornerOverlay extends StatelessWidget {
  final Widget? child;
  final double cornerLength;
  final double strokeWidth;
  final double radius;
  final Color color;
  final Color? outlineColor;
  final double outlineWidth;

  const ScannerCornerOverlay({
    super.key,
    this.child,
    this.cornerLength = 36,
    this.strokeWidth = 4.5,
    this.radius = 24,
    this.color = const Color(0xFFFA7E23),
    this.outlineColor,
    this.outlineWidth = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    final painter = _ScannerCornerPainter(
      cornerLength: cornerLength,
      strokeWidth: strokeWidth,
      radius: radius,
      color: color,
      outlineColor: outlineColor,
      outlineWidth: outlineWidth,
    );

    if (child != null) {
      return CustomPaint(foregroundPainter: painter, child: child);
    }
    return CustomPaint(size: Size.infinite, painter: painter);
  }
}

class _ScannerCornerPainter extends CustomPainter {
  final double cornerLength;
  final double strokeWidth;
  final double radius;
  final Color color;
  final Color? outlineColor;
  final double outlineWidth;

  _ScannerCornerPainter({
    required this.cornerLength,
    required this.strokeWidth,
    required this.radius,
    required this.color,
    this.outlineColor,
    this.outlineWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Optional subtle outline connecting the corners
    if (outlineColor != null && outlineColor != Colors.transparent) {
      final outlinePaint = Paint()
        ..color = outlineColor!
        ..strokeWidth = outlineWidth
        ..style = PaintingStyle.stroke;

      final halfOutline = outlineWidth / 2;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          halfOutline,
          halfOutline,
          w - outlineWidth,
          h - outlineWidth,
        ),
        Radius.circular((radius - halfOutline).clamp(0.0, double.infinity)),
      );
      canvas.drawRRect(rrect, outlinePaint);
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final halfStroke = strokeWidth / 2;
    final effRadius = (radius - halfStroke).clamp(1.0, double.infinity);

    // Top-Left corner
    final tlPath = Path()
      ..moveTo(halfStroke, cornerLength)
      ..lineTo(halfStroke, radius)
      ..arcToPoint(
        Offset(radius, halfStroke),
        radius: Radius.circular(effRadius),
        clockwise: true,
      )
      ..lineTo(cornerLength, halfStroke);
    canvas.drawPath(tlPath, paint);

    // Top-Right corner
    final trPath = Path()
      ..moveTo(w - cornerLength, halfStroke)
      ..lineTo(w - radius, halfStroke)
      ..arcToPoint(
        Offset(w - halfStroke, radius),
        radius: Radius.circular(effRadius),
        clockwise: true,
      )
      ..lineTo(w - halfStroke, cornerLength);
    canvas.drawPath(trPath, paint);

    // Bottom-Right corner
    final brPath = Path()
      ..moveTo(w - halfStroke, h - cornerLength)
      ..lineTo(w - halfStroke, h - radius)
      ..arcToPoint(
        Offset(w - radius, h - halfStroke),
        radius: Radius.circular(effRadius),
        clockwise: true,
      )
      ..lineTo(w - cornerLength, h - halfStroke);
    canvas.drawPath(brPath, paint);

    // Bottom-Left corner
    final blPath = Path()
      ..moveTo(cornerLength, h - halfStroke)
      ..lineTo(radius, h - halfStroke)
      ..arcToPoint(
        Offset(halfStroke, h - radius),
        radius: Radius.circular(effRadius),
        clockwise: true,
      )
      ..lineTo(halfStroke, h - cornerLength);
    canvas.drawPath(blPath, paint);
  }

  @override
  bool shouldRepaint(covariant _ScannerCornerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.cornerLength != cornerLength ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.outlineColor != outlineColor ||
        oldDelegate.outlineWidth != outlineWidth;
  }
}
