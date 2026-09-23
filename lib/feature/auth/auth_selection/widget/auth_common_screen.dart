import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class AuthCommonScreen extends StatelessWidget {
  const AuthCommonScreen({
    super.key,
    required this.child,
    this.bottomSafeArea = true,
  });

  final Widget child;
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageAssets.authBg,
            fit: BoxFit.fill,
            opacity: const AlwaysStoppedAnimation(0.5),
            gaplessPlayback: true,
          ),
          SafeArea(bottom: bottomSafeArea, child: child),
        ],
      ),
    );
  }
}
