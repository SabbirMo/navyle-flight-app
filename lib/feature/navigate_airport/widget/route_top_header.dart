import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_category_chips.dart';
import 'package:navyla_flight_app/feature/navigate_airport/widget/route_search_bar.dart';

class RouteTopHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onSearchClear;
  final VoidCallback? onMicTap;
  final VoidCallback? onAvatarTap;
  final List<RouteCategoryChip> chips;
  final String selectedChipId;
  final ValueChanged<RouteCategoryChip> onChipTap;
  final VoidCallback? onBackTap;

  const RouteTopHeader({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.onSearchClear,
    this.onMicTap,
    this.onAvatarTap,
    required this.chips,
    required this.selectedChipId,
    required this.onChipTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Navigation Bar Row
              Row(
                children: [
                  GestureDetector(
                    onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 14.sp,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'NAVIGATE YOUR ROUTE',
                        style: GoogleFonts.inter(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 38.w), // Balance back button
                ],
              ),
              SizedBox(height: 14.h),

              // Search Bar
              RouteSearchBar(
                controller: searchController,
                onChanged: onSearchChanged,
                onClear: onSearchClear,
                onMicTap: onMicTap,
                onAvatarTap: onAvatarTap,
              ),
              SizedBox(height: 12.h),

              // Chips Row
              RouteCategoryChips(
                chips: chips,
                selectedChipId: selectedChipId,
                onChipTap: onChipTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
