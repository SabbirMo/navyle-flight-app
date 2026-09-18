import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/image_manager/image_manager.dart';

class AuthCommonScreen extends StatelessWidget {
  const AuthCommonScreen({
    super.key,
    required this.child,
    this.bottomSafeArea = true,
    this.backgroundImageOpacity = 0.5,
    this.bgTopOffset = -60.0,
  });

  final Widget child;
  final bool bottomSafeArea;
  final double backgroundImageOpacity;
  final double bgTopOffset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Shifted background image upwards so bottom leaf and dots are visible
          Positioned(
            top: bgTopOffset.h,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              ImageManager.authBg,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              opacity: AlwaysStoppedAnimation(backgroundImageOpacity),
            ),
          ),
          SafeArea(bottom: bottomSafeArea, child: child),
        ],
      ),
    );
  }
}
