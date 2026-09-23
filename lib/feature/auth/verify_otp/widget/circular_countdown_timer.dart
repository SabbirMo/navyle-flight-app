import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class CircularCountdownTimer extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const CircularCountdownTimer({
    super.key,
    required this.remainingSeconds,
    this.totalSeconds = 60,
  });

  String get _formattedTime {
    final int minutes = remainingSeconds ~/ 60;
    final int seconds = remainingSeconds % 60;
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  double get _progress {
    if (totalSeconds <= 0) return 0.0;
    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circular Track and Progress Arc
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: _progress, end: _progress),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return SizedBox(
                width: 120.w,
                height: 120.w,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: 7.5.w,
                  strokeCap: StrokeCap.round,
                  backgroundColor: const Color(0xFFEFF3F8),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryColor,
                  ),
                ),
              );
            },
          ),
          // Timer text (e.g. 00:42)
          Text(
            _formattedTime,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
