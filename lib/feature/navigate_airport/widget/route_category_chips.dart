import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/feature/navigate_airport/model/airport_route_model.dart';

class RouteCategoryChips extends StatelessWidget {
  final List<RouteCategoryChip> chips;
  final String selectedChipId;
  final ValueChanged<RouteCategoryChip> onChipTap;

  const RouteCategoryChips({
    super.key,
    required this.chips,
    required this.selectedChipId,
    required this.onChipTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = chip.id == selectedChipId;
          final isPrimary = chip.isPrimary || isSelected;

          return GestureDetector(
            onTap: () => onChipTap(chip),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.white : AppColors.white,
                borderRadius: BorderRadius.circular(26.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.blue2563EB.withValues(alpha: 0.4)
                      : const Color(0xFFE2E8F0),
                  width: isSelected ? 1.4 : 1.0,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.1),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chip.icon,
                    size: 16.sp,
                    color: isPrimary
                        ? Color(0xff1A73E8)
                        : AppColors.lightBlueGray,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    chip.label,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w600,
                      color: isPrimary
                          ? Color(0xff1A73E8)
                          : AppColors.lightBlueGray,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
