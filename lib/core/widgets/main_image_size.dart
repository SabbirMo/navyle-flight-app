import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class MainImageSize extends StatelessWidget {
  const MainImageSize({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageAssets.appLogo,
      width: 64.w,
      height: 64.w,
      fit: BoxFit.contain,
    );
  }
}
