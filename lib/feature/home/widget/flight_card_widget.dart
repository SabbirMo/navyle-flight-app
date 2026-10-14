import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/router/app_pages.dart';

class FlightCardWidget extends ConsumerStatefulWidget {
  const FlightCardWidget({super.key});

  @override
  ConsumerState<FlightCardWidget> createState() => _FlightCardWidgetState();
}

class _FlightCardWidgetState extends ConsumerState<FlightCardWidget>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin, RouteAware {
  /// Static position matching the client's picture (~15 degrees perspective tilt)
  static const double _settledTilt = 0.85;

  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  double _dragOffset = 0.0;
  bool _isDragging = false;
  AnimationController? _springController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );

    _setupAnimation();
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute != null) {
      appRouteObserver.subscribe(this, modalRoute);
    }
  }

  void _setupAnimation() {
    _tiltAnimation = TweenSequence<double>([
      // --- SWAY 1: First complete back-and-forth sway (3.5s) ---
      // 1. Initial gentle glide right from flat (0.0) to peak (+0.95)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeOutSine)),
        weight: 8.0, // ~800ms
      ),
      // 2. Smooth, uninterrupted sway left across center to opposite crest (-0.60)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.95,
          end: -0.60,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 13.5, // ~1350ms
      ),
      // 3. Return sway through center back to right crest (+0.90) - completes 1st full sway!
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.60,
          end: 0.90,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 13.5, // ~1350ms
      ),

      // --- SWAY 2: Second complete back-and-forth sway (3.5s) ---
      // 4. Smooth, uninterrupted sway left across center to opposite crest (-0.45)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.90,
          end: -0.45,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 14.0, // ~1400ms
      ),
      // 5. Final movement towards the static tilted position: gradually reduce speed so it settles softly
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -0.45,
          end: _settledTilt,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight:
            21.0, // ~2100ms - extended gradual deceleration tail for soft, cushioned settling
      ),
    ]).animate(_controller);
  }

  void _animateBackToSettled() {
    final start = _dragOffset;
    const end = _settledTilt;
    _springController?.dispose();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    final anim = Tween<double>(begin: start, end: end).animate(
      CurvedAnimation(parent: _springController!, curve: Curves.easeOutCubic),
    );
    anim.addListener(() {
      if (mounted) {
        setState(() {
          _dragOffset = anim.value;
        });
      }
    });
    _springController!.forward();
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    _controller.dispose();
    _springController?.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Replay animation when user returns to Home from another pushed route
    final currentTab = ref.read(navbarNotifierProvider);
    if (currentTab == 0) {
      _replayIntro();
    }
  }

  void _replayIntro() {
    if (!mounted) return;
    _springController?.stop();
    _isDragging = false;
    _dragOffset = 0.0;
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Replay animation when user returns to Home from another tab
    ref.listen<int>(navbarNotifierProvider, (previous, next) {
      if (next == 0 && previous != 0) {
        _replayIntro();
      }
    });

    final journey = ref.watch(flightJourneyNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(22.r),
      child: Stack(
        children: [
          // 1. Background Runway Airplane Image (photorealistic, clean, borderless)
          Positioned.fill(
            child: Image.asset(ImageAssets.airplane, fit: BoxFit.cover),
          ),

          // 2. Card Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
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
                            fontSize: 10.5.sp,
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
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          journey.flightNumber?.isNotEmpty == true
                              ? journey.flightNumber!
                              : 'BA 0215',
                          style: TextStyle(
                            fontFamily: 'SF-Pro',
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),

                    // "On Time" Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blackShadow.withValues(alpha: 0.86),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF76FF03),
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            "On Time",
                            style: GoogleFonts.inter(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF91EE26),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Middle Row: Origin (AMS) -> Flight -> Destination (FRA)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _cityBlock('AMS', 'AMSTERDAM', CrossAxisAlignment.start),
                    Row(
                      children: [
                        Container(
                          width: 28.w,
                          height: 1.5,
                          color: const Color(0xFF334155),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Transform.rotate(
                            angle: 90 * math.pi / 180,
                            child: const Icon(
                              Icons.flight,
                              size: 20,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: 28.w,
                          height: 1.5,
                          color: const Color(0xFF334155),
                        ),
                      ],
                    ),
                    _cityBlock('FRA', 'FRANKFURT', CrossAxisAlignment.end),
                  ],
                ),

                SizedBox(height: 6.h),

                // Orange Divider
                Container(height: 1, color: const Color(0xFFFF9233)),

                SizedBox(height: 6.h),

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
        final effectiveTilt =
            _isDragging || (_springController?.isAnimating == true)
            ? _dragOffset.clamp(-1.0, 1.0)
            : _tiltAnimation.value;

        // 3D perspective angles matching Image 2:
        // Left side tilts forward towards viewer (+Z)
        // Right side recedes inwards into the screen (-Z)
        final angleY = -effectiveTilt * (16.0 * math.pi / 180);
        final angleZ = effectiveTilt * 0.024;

        // 3D tactile extrusion offset to reveal card thickness on the tilted side (ultra slim & refined)
        final extrusionOffset = (effectiveTilt.abs() * 2.2.w).clamp(0.0, 3.0.w);

        return GestureDetector(
          onHorizontalDragStart: (_) {
            setState(() {
              _isDragging = true;
              _controller.stop();
              _springController?.stop();
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.primaryDelta! / 130.0;
              _dragOffset = _dragOffset.clamp(-1.0, 1.0);
            });
          },
          onHorizontalDragEnd: (_) {
            setState(() {
              _isDragging = false;
            });
            _animateBackToSettled();
          },
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0016) // 3D perspective
              ..rotateY(angleY)
              ..rotateZ(angleZ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. 3D Physical Extruded Card Body (Tactile thickness & depth on the tilted side)
                Positioned(
                  left: effectiveTilt > 0 ? -extrusionOffset : 0,
                  right: effectiveTilt < 0 ? -extrusionOffset : 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(
                            0xFFE65100,
                          ), // Darker orange edge for physical 3D bevel
                          Color(0xFFFA7E23), // Rich orange body
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFF6D00,
                          ).withValues(alpha: isDark ? 0.25 : 0.16),
                          blurRadius: 14,
                          offset: Offset(-effectiveTilt * 4.5.w, 7.h),
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.08,
                          ),
                          blurRadius: 8,
                          offset: Offset(-effectiveTilt * 2.0.w, 4.h),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Front Face Card (Crisp content with thin refined front outline)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: const Color(0xFFFF9233).withValues(alpha: 0.85),
                      width: 0.8.w,
                    ),
                  ),
                  child: cachedCard,
                ),
              ],
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
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          city.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 9.5.sp,
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
            fontSize: 8.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackShadow,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 15.sp,
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
      height: 20.h,
      color: Colors.grey.withValues(alpha: 0.4),
    );
  }
}
