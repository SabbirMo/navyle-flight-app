import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';

class FlightCardWidget extends ConsumerStatefulWidget {
  const FlightCardWidget({super.key});

  @override
  ConsumerState<FlightCardWidget> createState() => _FlightCardWidgetState();
}

class _FlightCardWidgetState extends ConsumerState<FlightCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _tiltAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journey = ref.watch(flightJourneyNotifierProvider);

    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: Stack(
        children: [
          // 1. Background Runway Airplane Image
          Positioned.fill(
            child: Image.asset(ImageAssets.airplane, fit: BoxFit.fill),
          ),

          // 2. Card Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Row: Countdown & Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEPARTURE IN',
                          style: GoogleFonts.inter(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          journey.departureCountdown?.isNotEmpty == true
                              ? journey.departureCountdown!
                              : '04:42:15',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          journey.flightNumber?.isNotEmpty == true
                              ? journey.flightNumber!
                              : 'BA 0215',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    // "On Time" Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blackShadow.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7.w,
                            height: 7.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF76FF03),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "On Time",
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF91EE26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // Middle Row: Origin (AMS) -> Flight -> Destination (FRA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cityBlock('AMS', 'AMSTERDAM', CrossAxisAlignment.start),
                    Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 1.5,
                          color: const Color(0xFF334155),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Transform.rotate(
                            angle: 90 * math.pi / 180,
                            child: const Icon(
                              Icons.flight,
                              size: 22,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 30.w,
                          height: 1.5,
                          color: const Color(0xFF334155),
                        ),
                      ],
                    ),
                    _cityBlock('FRA', 'FRANKFURT', CrossAxisAlignment.end),
                  ],
                ),

                SizedBox(height: 10.h),

                // Orange Divider
                Container(height: 1, color: const Color(0xFFFF9233)),

                SizedBox(height: 10.h),

                // Bottom Row: Terminal, Check-in, Gate, Seat
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoColumn(
                      'TERMINAL',
                      journey.terminal?.isNotEmpty == true
                          ? journey.terminal!
                          : 'T5',
                    ),
                    _divider(),
                    _infoColumn(
                      'CHECK IN',
                      journey.checkInTime?.isNotEmpty == true
                          ? journey.checkInTime!
                          : '8:00am',
                    ),
                    _divider(),
                    _infoColumn(
                      'GATE',
                      journey.gate?.isNotEmpty == true ? journey.gate! : 'B24',
                    ),
                    _divider(),
                    _infoColumn(
                      'SEAT',
                      journey.seat?.isNotEmpty == true ? journey.seat! : '14A',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedBuilder(
      animation: _tiltAnimation,
      child: cardContent,
      builder: (context, cachedCard) {
        // Effective tilt between -1.0 (left tilt) and 1.0 (right tilt)
        final effectiveTilt = _isDragging
            ? _dragOffset.clamp(-1.0, 1.0)
            : _tiltAnimation.value;

        // 3D tilt angle (18 degrees) for smooth dynamic left-right sway
        final angleY = effectiveTilt * (18 * math.pi / 180);
        final angleZ = effectiveTilt * 0.045;
        final shadowX = -effectiveTilt * 20.w;

        return GestureDetector(
          onHorizontalDragStart: (_) {
            setState(() {
              _isDragging = true;
              _controller.stop();
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.primaryDelta! / 120.0;
              _dragOffset = _dragOffset.clamp(-1.0, 1.0);
            });
          },
          onHorizontalDragEnd: (_) {
            setState(() {
              _isDragging = false;
              _dragOffset = 0.0;
              _controller.repeat(reverse: true);
            });
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0016) // 3D perspective
              ..rotateY(angleY)
              ..rotateZ(angleZ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6D00).withValues(alpha: 0.42),
                    blurRadius: 22,
                    offset: Offset(shadowX, 8),
                  ),
                ],
              ),
              child: cachedCard,
            ),
          ),
        );
      },
    );
  }

  Widget _cityBlock(String code, String city, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          code,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          city.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackShadow,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 24.h,
      color: Colors.grey.withValues(alpha: 0.4),
    );
  }
}
