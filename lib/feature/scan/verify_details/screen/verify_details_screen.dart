import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/widgets/common_screen.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/scan/verify_details/provider/verify_details_notifier.dart';
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
      text: isManual ? '' : (data['from'] ?? 'AMS'),
    );
    _toController = TextEditingController(
      text: isManual ? '' : (data['to'] ?? 'FRA'),
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

    // Initialize Riverpod state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(verifyDetailsNotifierProvider.notifier).initialize(
              isManual: isManual,
              initialData: widget.initialData,
            );
      }
    });
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

  void _syncControllersToNotifier() {
    final notifier = ref.read(verifyDetailsNotifierProvider.notifier);
    notifier.updateName(_nameController.text.trim());
    notifier.updateFlightNumber(_flightNumberController.text.trim());
    notifier.updateFrom(_fromController.text.trim());
    notifier.updateTo(_toController.text.trim());
    notifier.updateDate(_dateController.text.trim());
    notifier.updateSeat(_seatController.text.trim());
    notifier.updateTerminal(_terminalController.text.trim());
    notifier.updateGate(_gateController.text.trim());
  }

  void _handleConfirm() {
    _syncControllersToNotifier();
    final notifier = ref.read(verifyDetailsNotifierProvider.notifier);
    final success = notifier.submit();

    if (!success) {
      final formState = ref.read(verifyDetailsNotifierProvider);
      final emptyFields = formState.emptyFields;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  emptyFields.length == 1
                      ? 'Please enter ${emptyFields.first}.'
                      : 'Please fill in all required fields before continuing.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

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

    final picked = await showDatePicker(
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
      final formattedDate = '$dd/$mm/$yy';
      _dateController.text = formattedDate;
      ref
          .read(verifyDetailsNotifierProvider.notifier)
          .updateDate(formattedDate);
    }
  }

  Widget _buildCard({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    required bool showError,
    String? hintText,
    IconData? icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.characters,
    VoidCallback? onTap,
    bool readOnly = false,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBlack : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: showError
                ? const Color(0xFFEF4444)
                : (isDark
                      ? AppColors.lightBlueGray.withValues(alpha: 0.4)
                      : const Color(0xFFF1F5F9)),
            width: showError ? 1.6 : 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: showError
                  ? const Color(0xFFEF4444).withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    showError ? '$label *' : label,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: showError
                          ? const Color(0xFFEF4444)
                          : AppColors.lightGray,
                      letterSpacing: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showError)
                  Text(
                    'Required',
                    style: GoogleFonts.inter(
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFEF4444),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18.sp,
                    color: showError
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    onTap: onTap,
                    keyboardType: keyboardType,
                    textCapitalization: textCapitalization,
                    onChanged: onChanged,
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.white : AppColors.black,
                      letterSpacing: 0.3,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      fillColor: Colors.transparent,
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
    final formState = ref.watch(verifyDetailsNotifierProvider);
    final notifier = ref.read(verifyDetailsNotifierProvider.notifier);
    final isManual = formState.isManual || widget.isManual;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CommonScreen(
      child: Column(
        children: [
          SizedBox(height: 4.h),
          // Header with Back Button and centered VERIFY DETAILS title
          const CustomBackButton(title: 'VERIFY DETAILS', isBorder: true),
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
                      color: isDark
                          ? Colors.transparent
                          : const Color(0xFFDCFCE7).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightGray.withValues(alpha: 0.4)
                            : const Color(0xFF22C55E).withValues(alpha: 0.4),
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
                                  color: isDark
                                      ? AppColors.white
                                      : AppColors.black,
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
                                  color: isDark
                                      ? AppColors.lightBlueGray
                                      : AppColors.grayColor,
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
                    context: context,
                    label: 'NAME',
                    controller: _nameController,
                    showError: formState.hasAttemptedSubmit &&
                        _nameController.text.trim().isEmpty,
                    onChanged: (val) => notifier.updateName(val.trim()),
                    hintText: 'e.g. Alex Rivers',
                    icon: Icons.person_rounded,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                  ),
                  SizedBox(height: 12.h),

                  // Flight Number Field
                  _buildCard(
                    context: context,
                    label: 'FLIGHT NUMBER',
                    controller: _flightNumberController,
                    showError: formState.hasAttemptedSubmit &&
                        _flightNumberController.text.trim().isEmpty,
                    onChanged: (val) => notifier.updateFlightNumber(val.trim()),
                    hintText: 'e.g. BA 0215',
                    icon: Icons.flight_rounded,
                  ),
                  SizedBox(height: 12.h),

                  // From & To Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          context: context,
                          label: 'FROM',
                          controller: _fromController,
                          showError: formState.hasAttemptedSubmit &&
                              _fromController.text.trim().isEmpty,
                          onChanged: (val) => notifier.updateFrom(val.trim()),
                          hintText: 'e.g. AMS',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          context: context,
                          label: 'TO',
                          controller: _toController,
                          showError: formState.hasAttemptedSubmit &&
                              _toController.text.trim().isEmpty,
                          onChanged: (val) => notifier.updateTo(val.trim()),
                          hintText: 'e.g. FRA',
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
                          context: context,
                          label: 'DATE',
                          controller: _dateController,
                          showError: formState.hasAttemptedSubmit &&
                              _dateController.text.trim().isEmpty,
                          onChanged: (val) => notifier.updateDate(val.trim()),
                          hintText: 'e.g. 24/09/26',
                          readOnly: true,
                          onTap: _selectDate,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          context: context,
                          label: 'SEAT',
                          controller: _seatController,
                          showError: formState.hasAttemptedSubmit &&
                              _seatController.text.trim().isEmpty,
                          onChanged: (val) => notifier.updateSeat(val.trim()),
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
                          context: context,
                          label: 'TERMINAL',
                          controller: _terminalController,
                          showError: formState.hasAttemptedSubmit &&
                              _terminalController.text.trim().isEmpty,
                          onChanged: (val) =>
                              notifier.updateTerminal(val.trim()),
                          hintText: 'e.g. 5',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildCard(
                          context: context,
                          label: 'GATE',
                          controller: _gateController,
                          showError: formState.hasAttemptedSubmit &&
                              _gateController.text.trim().isEmpty,
                          onChanged: (val) => notifier.updateGate(val.trim()),
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
                      color: isDark
                          ? AppColors.darkBlack
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isDark
                            ? AppColors.lightBlueGray.withValues(alpha: 0.4)
                            : const Color(0xFFBFDBFE),
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
