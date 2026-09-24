import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

/// Data model representing a Quick Access Tool card on the Home Screen.
class QuickAccessToolModel {
  final String id;
  final String title;
  final String subtitle;
  final String bgImage;
  final Widget iconWidget;
  final Widget? overlayWidget;
  final bool isChevronAtEnd;
  final VoidCallback? onTap;

  const QuickAccessToolModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    required this.iconWidget,
    this.overlayWidget,
    this.isChevronAtEnd = true,
    this.onTap,
  });

  /// Default list of 4 quick access tools matching the design.
  static List<QuickAccessToolModel> get defaultTools => [
    // 1. Airport Navigation
    QuickAccessToolModel(
      id: 'airport_navigation',
      title: 'Airport Navigation',
      subtitle: 'FIND YOUR WAY',
      bgImage: ImageAssets.airportNav,
      isChevronAtEnd: true,
      iconWidget: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Icon(
              Icons.turn_right_rounded,
              color: Colors.white,
              size: 15.sp,
            ),
          ),
        ),
      ),
    ),

    // 2. Boarding Pass
    QuickAccessToolModel(
      id: 'boarding_pass',
      title: 'Boarding pass',
      subtitle: 'VIEW YOUR PASS',
      bgImage: ImageAssets.boardingPass,
      isChevronAtEnd: true,
      iconWidget: Icon(
        Icons.airplane_ticket_outlined,
        color: const Color(0xFF007AFF),
        size: 22.sp,
      ),
    ),

    // 3. Explore Nearby
    QuickAccessToolModel(
      id: 'explore_nearby',
      title: 'Explore nearby',
      subtitle: 'SHOP, FOODS & MORE',
      bgImage: ImageAssets.exploreNearby,
      isChevronAtEnd: true,
      iconWidget: Icon(
        Icons.shopping_bag_rounded,
        color: const Color(0xFF7C3AED),
        size: 20.sp,
      ),
    ),

    // 4. Ask NAVYLA
    QuickAccessToolModel(
      id: 'ask_navyla',
      title: 'Ask NAVYLA',
      subtitle: 'YOUR AI ASSISTANT',
      bgImage: ImageAssets.navylaBg,
      isChevronAtEnd: true,
      iconWidget: Padding(
        padding: EdgeInsets.all(3.w),
        child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
      ),
      overlayWidget: Positioned(
        top: 10.h,
        right: 10.w,
        width: 64.w,
        height: 64.h,
        child: Opacity(
          opacity: 0.72,
          child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
        ),
      ),
    ),
  ];
}
