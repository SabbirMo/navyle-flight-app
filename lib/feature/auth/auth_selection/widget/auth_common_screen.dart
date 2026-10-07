import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class AuthCommonScreen extends StatelessWidget {
  const AuthCommonScreen({
    super.key,
    required this.child,
    this.bottomSafeArea = true,
    this.resizeToAvoidBottomInset,
  });

  final Widget child;
  final bool bottomSafeArea;
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: isDark ? AppColors.blackShadow : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageAssets.authBg,
            fit: BoxFit.fill,
            opacity: isDark
                ? const AlwaysStoppedAnimation(0.29)
                : const AlwaysStoppedAnimation(0.5),
            gaplessPlayback: true,
          ),
          SafeArea(bottom: bottomSafeArea, child: child),
        ],
      ),
    );
  }
}
