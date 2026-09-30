import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class AppleWatchDeviceView extends StatelessWidget {
  final double? height;
  final double? width;

  const AppleWatchDeviceView({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageAssets.appleWatch,
      height: height ?? 130.h,
      width: width ?? 110.w,
      fit: BoxFit.contain,
    );
  }
}

class WearOsWatchDeviceView extends StatelessWidget {
  final double? height;
  final double? width;

  const WearOsWatchDeviceView({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageAssets.smartWatch,
      height: height ?? 130.h,
      width: width ?? 118.w,
      fit: BoxFit.contain,
    );
  }
}
