import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class VerifyDetailsScreen extends ConsumerStatefulWidget {
  final bool isManual;
  final Map<String, String>? initialData;

  const VerifyDetailsScreen({
    super.key,
    this.isManual = false,
    this.initialData,
  });

  @override
  ConsumerState<VerifyDetailsScreen> createState() =>
      _VerifyDetailsScreenState();
}

class _VerifyDetailsScreenState extends ConsumerState<VerifyDetailsScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _flightNumberController;
  late final TextEditingController _fromController;
  late final TextEditingController _toController;
  late final TextEditingController _dateController;
  late final TextEditingController _seatController;
  late final TextEditingController _terminalController;
  late final TextEditingController _gateController;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData ?? {};
    final isManual = widget.isManual;

    _nameController = TextEditingController(
      text: isManual ? '' : (data['name'] ?? 'ALEX RIVERS'),
    );
    _flightNumberController = TextEditingController(
      text: isManual ? '' : (data['flightNumber'] ?? 'BA 0215'),
    );
    _fromController = TextEditingController(
      text: isManual ? '' : (data['from'] ?? 'LHR'),
    );
    _toController = TextEditingController(
      text: isManual ? '' : (data['to'] ?? 'JFK'),
    );
    _dateController = TextEditingController(
      text: isManual ? '' : (data['date'] ?? '24/09/26'),
    );
    _seatController = TextEditingController(
      text: isManual ? '' : (data['seat'] ?? '14A'),
    );
    _terminalController = TextEditingController(
      text: isManual ? '' : (data['terminal'] ?? '5'),
    );
    _gateController = TextEditingController(
      text: isManual ? '' : (data['gate'] ?? 'B24'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _flightNumberController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _seatController.dispose();
    _terminalController.dispose();
    _gateController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    final flightNum = _flightNumberController.text.trim();

    ref
        .read(flightJourneyNotifierProvider.notifier)
        .addBoardingPass(
          flightNumber: flightNum.isNotEmpty ? flightNum : 'BA 0215',
          originCode: _fromController.text.trim().isNotEmpty
              ? _fromController.text.trim()
              : 'AMS',
          destinationCode: _toController.text.trim().isNotEmpty
              ? _toController.text.trim()
              : 'FRA',
          seat: _seatController.text.trim().isNotEmpty
              ? _seatController.text.trim()
              : '14A',
          gate: _gateController.text.trim().isNotEmpty
              ? _gateController.text.trim()
              : 'B24',
          terminal: _terminalController.text.trim().isNotEmpty
              ? _terminalController.text.trim()
              : 'T5',
          flightDate: _dateController.text.trim().isNotEmpty
              ? _dateController.text.trim()
              : '24 Sep',
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          flightNum.isNotEmpty
              ? 'Boarding pass for $flightNum confirmed!'
              : 'Boarding pass confirmed and added to your tickets!',
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go(AppRouterName.navbarScreen);
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    if (_dateController.text.isNotEmpty) {
      final parts = _dateController.text.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        int? year = int.tryParse(parts[2]);
        if (year != null && year < 100) {
          year += 2000;
        }
        if (day != null && month != null && year != null) {
          try {
            initialDate = DateTime(year, month, day);
          } catch (_) {}
        }
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: AppColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final dd = picked.day.toString().padLeft(2, '0');
      final mm = picked.month.toString().padLeft(2, '0');
      final yy = (picked.year % 100).toString().padLeft(2, '0');
      setState(() {
        _dateController.text = '$dd/$mm/$yy';
      });
    }
  }

  Widget _buildCard({
    required String label,
    required TextEditingController controller,
    String? hintText,
    IconData? icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.characters,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.lightGray,
                letterSpacing: 1.1,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18.sp, color: const Color(0xFF94A3B8)),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    keyboardType: keyboardType,
                    textCapitalization: textCapitalization,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                      letterSpacing: 0.3,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hintText,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isManual = widget.isManual;

    return CommonScreen(
      child: Column(
        children: [
          SizedBox(height: 4.h),
          // Header with Back Button and centered VERIFY DETAILS title
          const CustomBackButton(title: 'VERIFY DETAILS'),
          SizedBox(height: 18.h),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Banner Card (Extracted or Manual Entry)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.4),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF22C55E),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isManual
                                    ? 'ENTER FLIGHT DETAILS'
                                    : 'EXTRACTED SUCCESSFUL',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                isManual
                                    ? 'Please type in your flight details below.'
                                    : 'Please review the details below.',
                                style: GoogleFonts.inter(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.grayColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Name Field
                  _buildCard(
                    label: 'NAME',
                    controller: _nameController,
                    hintText: 'e.g. Alex Rivers',
                    icon: Icons.person_rounded,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 12.h),

                  // Flight Number Field
                  _buildCard(
                    label: 'FLIGHT NUMBER',
                    controller: _flightNumberController,
                    hintText: 'e.g. BA 0215',
                    icon: Icons.flight_rounded,
                  ),
                  SizedBox(height: 12.h),

                  // From & To Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          label: 'FROM',
                          controller: _fromController,
                          hintText: 'e.g. LHR',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          label: 'TO',
                          controller: _toController,
                          hintText: 'e.g. JFK',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Date & Seat Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          label: 'DATE',
                          controller: _dateController,
                          hintText: 'e.g. 24/09/26',
                          readOnly: true,
                          onTap: _selectDate,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          label: 'SEAT',
                          controller: _seatController,
                          hintText: 'e.g. 14A',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Terminal & Gate Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          label: 'TERMINAL',
                          controller: _terminalController,
                          hintText: 'e.g. 5',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          label: 'GATE',
                          controller: _gateController,
                          hintText: 'e.g. B24',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),

                  // Disclaimer Banner
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFBFDBFE),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'NAVYLA uses AI to extract this information. Incorrect data may affect your real-time alerts.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2563EB),
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Confirm & Create Pass Button
                  CustomButton(
                    text: 'Confirm & Create Pass',
                    boxShadow: true,
                    onTap: _handleConfirm,
                  ),
                  SizedBox(height: 36.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
