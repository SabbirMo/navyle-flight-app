import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';

class NotificationSectionHeader extends StatelessWidget {
  final String title;
  final double topPadding;

  const NotificationSectionHeader({
    super.key,
    required this.title,
    this.topPadding = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding.h, bottom: 10.h, left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.lightGray,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
