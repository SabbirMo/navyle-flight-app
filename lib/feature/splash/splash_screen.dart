import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/theme/theme_mode_provder.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotationAnimation;
  late final Animation<double> _effectFadeAnimation;
  late final Animation<double> _effectScaleAnimation;
  late final Animation<Offset> _effectSlideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // 1. Logo slow & smooth entrance: fade-in and scale to 1.0 (no bounce)
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );
    _logoScaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.38, curve: Curves.easeOutCubic),
      ),
    );

    // 2. Logo 3D 360-degree rotation: spins smoothly horizontally when effect enters from bottom
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.85, curve: Curves.easeInOutCubic),
      ),
    );

    // 3. Effect Animation: slides smoothly from bottom while fading in
    _effectFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.68, curve: Curves.easeIn),
      ),
    );
    _effectScaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 0.85, curve: Curves.easeOutCubic),
      ),
    );
    _effectSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.38, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.pushReplacement(AppRouterName.onBoardingScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? null : AppColors.splashGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _logoFadeAnimation,
                child: ScaleTransition(
                  scale: _logoScaleAnimation,
                  child: AnimatedBuilder(
                    animation: _logoRotationAnimation,
                    builder: (context, child) {
                      final angle = _logoRotationAnimation.value * 2 * math.pi;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.0015)
                          ..rotateY(angle),
                        child: child,
                      );
                    },
                    child: Image.asset(ImageAssets.appLogo, width: 130.w),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _effectFadeAnimation,
                child: SlideTransition(
                  position: _effectSlideAnimation,
                  child: ScaleTransition(
                    scale: _effectScaleAnimation,
                    child: Image.asset(
                      isDark ? ImageAssets.effect2 : ImageAssets.effect,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
