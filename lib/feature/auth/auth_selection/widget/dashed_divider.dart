import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({
    super.key,
    required this.text,
    this.lineColor = const Color(0xFFD1D5DB),
    this.textColor = const Color(0xFF8A817A),
  });

  final String text;
  final Color lineColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: DashedLine(color: lineColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            text,
            style: StyleManager.interMedium12(textColor).copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(child: DashedLine(color: lineColor)),
      ],
    );
  }
}

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.height = 1.0,
    this.color = const Color(0xFFD1D5DB),
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
  });

  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
