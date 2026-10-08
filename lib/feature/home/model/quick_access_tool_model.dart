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
  final String? darkBgImage;
  final Widget iconWidget;
  final Widget? darkIconWidget;
  final Widget? overlayWidget;
  final Widget? darkOverlayWidget;
  final bool isChevronAtEnd;
  final VoidCallback? onTap;

  const QuickAccessToolModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    this.darkBgImage,
    required this.iconWidget,
    this.darkIconWidget,
    this.overlayWidget,
    this.darkOverlayWidget,
    this.isChevronAtEnd = true,
    this.onTap,
  });

  QuickAccessToolModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? bgImage,
    String? darkBgImage,
    Widget? iconWidget,
    Widget? darkIconWidget,
    Widget? overlayWidget,
    Widget? darkOverlayWidget,
    bool? isChevronAtEnd,
    VoidCallback? onTap,
  }) {
    return QuickAccessToolModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      bgImage: bgImage ?? this.bgImage,
      darkBgImage: darkBgImage ?? this.darkBgImage,
      iconWidget: iconWidget ?? this.iconWidget,
      darkIconWidget: darkIconWidget ?? this.darkIconWidget,
      overlayWidget: overlayWidget ?? this.overlayWidget,
      darkOverlayWidget: darkOverlayWidget ?? this.darkOverlayWidget,
      isChevronAtEnd: isChevronAtEnd ?? this.isChevronAtEnd,
      onTap: onTap ?? this.onTap,
    );
  }

  /// Default list of 4 quick access tools matching the design.
  static List<QuickAccessToolModel> get defaultTools => [
    // 1. Airport Navigation
    QuickAccessToolModel(
      id: 'airport_navigation',
      title: 'Airport Navigation',
      subtitle: 'FIND YOUR WAY',
      bgImage: ImageAssets.airportNav,
      darkBgImage: ImageAssets.darkAirportNav,
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
      darkIconWidget: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: Icon(
              Icons.turn_right_rounded,
              color: const Color(0xFF1E293B),
              size: 14.sp,
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
      darkBgImage: ImageAssets.darkBoardingPass,
      isChevronAtEnd: true,
      iconWidget: Padding(
        padding: EdgeInsets.all(6.w),
        child: Image.asset(ImageAssets.boardingPassIcon, fit: BoxFit.contain),
      ),
      darkIconWidget: Padding(
        padding: EdgeInsets.all(6.w),
        child: Image.asset(
          ImageAssets.boardingPassIcon,
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
    ),

    // 3. Explore Nearby
    QuickAccessToolModel(
      id: 'explore_nearby',
      title: 'Explore nearby',
      subtitle: 'SHOP, FOODS & MORE',
      bgImage: ImageAssets.exploreNearby,
      darkBgImage: ImageAssets.darkExploreNearby,
      isChevronAtEnd: true,
      iconWidget: Icon(
        Icons.shopping_bag_rounded,
        color: const Color(0xFF7C3AED),
        size: 20.sp,
      ),
      darkIconWidget: const Icon(
        Icons.shopping_bag_rounded,
        color: Colors.white,
        size: 20,
      ),
    ),

    // 4. Ask NAVYLA
    QuickAccessToolModel(
      id: 'ask_navyla',
      title: 'Ask NAVYLA',
      subtitle: 'YOUR AI ASSISTANT',
      bgImage: ImageAssets.navylaBg,
      darkBgImage: ImageAssets.darkNavylaBg,
      isChevronAtEnd: true,
      iconWidget: Padding(
        padding: EdgeInsets.all(3.w),
        child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
      ),
      darkIconWidget: Padding(
        padding: EdgeInsets.all(3.w),
        child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
      ),
      overlayWidget: Positioned(
        top: 14.h,
        right: 10.w,
        width: 55.w,
        height: 55.h,
        child: Opacity(
          opacity: 0.72,
          child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
        ),
      ),
      darkOverlayWidget: Positioned(
        top: 0.h,
        right: 4.w,
        bottom: 6.h,
        width: 55.w,
        child: Opacity(
          opacity: 0.7,
          child: Image.asset(ImageAssets.navylaAi, fit: BoxFit.contain),
        ),
      ),
    ),
  ];
}
