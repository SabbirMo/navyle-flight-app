import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';

class RouteSearchSuggestions extends StatelessWidget {
  final List<AirportPointOfInterest> suggestions;
  final ValueChanged<AirportPointOfInterest> onSelect;

  const RouteSearchSuggestions({
    super.key,
    required this.suggestions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (suggestions.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.textFieldBgColor : Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'No matching locations found',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: isDark ? AppColors.lightGray : const Color(0xFF64748B),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      constraints: BoxConstraints(maxHeight: 240.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.textFieldBgColor : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          shrinkWrap: true,
          itemCount: suggestions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: isDark
                ? AppColors.white.withValues(alpha: 0.08)
                : const Color(0xFFF1F5F9),
            indent: 52.w,
          ),
          itemBuilder: (context, index) {
            final poi = suggestions[index];
            return InkWell(
              onTap: () => onSelect(poi),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkBlack
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        poi.icon,
                        size: 18.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            poi.name,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            poi.subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              color: isDark
                                  ? AppColors.lightGray
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.blue2563EB.withValues(alpha: 0.2)
                            : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        poi.walkingMinutes,
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.blueShadow
                              : AppColors.blue2563EB,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
