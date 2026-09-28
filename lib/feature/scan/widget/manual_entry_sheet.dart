import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';

class ManualEntrySheet extends StatefulWidget {
  final Function(String flightNumber, String gate, String seat)? onConfirm;

  const ManualEntrySheet({super.key, this.onConfirm});

  static Future<void> show(
    BuildContext context, {
    Function(String flightNumber, String gate, String seat)? onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ManualEntrySheet(onConfirm: onConfirm),
    );
  }

  @override
  State<ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends State<ManualEntrySheet> {
  final _flightController = TextEditingController(text: 'BA 0215');
  final _gateController = TextEditingController(text: 'B24');
  final _seatController = TextEditingController(text: '14A');

  @override
  void dispose() {
    _flightController.dispose();
    _gateController.dispose();
    _seatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: bottomInset + 24.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Title
          Text(
            "Manual Ticket Entry",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Enter your boarding pass details directly",
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 20.h),

          // Flight Number Input
          _buildTextField(
            label: "FLIGHT NUMBER",
            controller: _flightController,
            hint: "e.g. BA 0215",
            icon: Icons.flight_takeoff_rounded,
          ),
          SizedBox(height: 14.h),

          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: "GATE",
                  controller: _gateController,
                  hint: "e.g. B24",
                  icon: Icons.meeting_room_outlined,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  label: "SEAT",
                  controller: _seatController,
                  hint: "e.g. 14A",
                  icon: Icons.event_seat_outlined,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          CustomButton(
            text: "Load Boarding Pass",
            height: 44.h,
            boxShadow: true,
            onTap: () {
              widget.onConfirm?.call(
                _flightController.text.trim(),
                _gateController.text.trim(),
                _seatController.text.trim(),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF8A9BA8),
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Icon(icon, size: 18.sp, color: AppColors.primaryColor),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: const Color(0xFF94A3B8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
