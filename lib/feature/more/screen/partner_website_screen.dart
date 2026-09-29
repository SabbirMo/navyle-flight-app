import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/app_string/app_string.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/core/widgets/custom_input_field.dart';
import 'package:navyla_flight_app/feature/more/model/more_model.dart';

class PartnerWebsiteScreen extends StatefulWidget {
  const PartnerWebsiteScreen({super.key, this.data});

  final MoreModel? data;

  @override
  State<PartnerWebsiteScreen> createState() => _PartnerWebsiteScreenState();
}

class _PartnerWebsiteScreenState extends State<PartnerWebsiteScreen> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _datesController = TextEditingController();
  DateTime? _selectedDate;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<BoxShadow> _closeBtnShadow = [
    BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> _cardShadow = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    _datesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _datesController.text =
            '${_months[picked.month - 1]} ${picked.day}, ${picked.year}';
      });
    }
  }

  void _onSearch(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Connecting to $title partner...',
          style: StyleManager.interMedium13(Colors.white),
        ),
        backgroundColor: const Color(0xFFFA8A35),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.data?.partnerText ?? AppString.hotelPartnerText;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: 24.h + bottomInset),
              child: Column(
                children: [
                  SizedBox(height: 8.h),

                  // // Top Header
                  _buildHeader(context),

                  SizedBox(height: 24.h),

                  // Main Partner Card
                  _buildPartnerCard(title),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Circular Close 'X' Button
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 38.w,
            height: 38.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
              boxShadow: _closeBtnShadow,
            ),
            child: Center(
              child: Icon(
                Icons.close_rounded,
                size: 20.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ),

        // Center Title & URL
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.partnerWebsite,
              style: StyleManager.interSemiBold14(
                AppColors.black,
              ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline_rounded,
                  size: 12.sp,
                  color: const Color(0xFF1E293B),
                ),
                SizedBox(width: 4.w),
                Text(
                  AppString.partnerWebsiteUrl,
                  style: StyleManager.interMedium12(
                    const Color(0xFF1E293B),
                  ).copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ],
        ),

        // Right Spacer for balance
        SizedBox(width: 38.w),
      ],
    );
  }

  Widget _buildPartnerCard(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: _cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orange Square with External Link Icon
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFFFA8A35),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Icon(
                Icons.open_in_new_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Title
          Text(
            title,
            style: StyleManager.interSemiBold14(AppColors.black).copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),

          SizedBox(height: 8.h),

          // Subtitle
          Text(
            AppString.partnerWebsiteSecurityNote,
            style: StyleManager.interRegular14(
              const Color(0xFF64748B),
            ).copyWith(fontSize: 13.sp, height: 1.45),
          ),

          SizedBox(height: 18.h),

          // 1. Destination Input
          CustomInputField(
            controller: _destinationController,
            hintText: AppString.airportOrDestination,
            hintStyle: StyleManager.interRegular13(const Color(0xFF64748B)),
            prefixIcon: Icons.place_outlined,
            prefixIconColor: const Color(0xFF64748B),
            prefixIconSize: 20.sp,
            borderRadius: 12.r,
            borderColor: const Color(0xFFE2E8F0),
            focusedBorderColor: const Color(0xFFFA8A35),
            height: 48.h,
          ),

          SizedBox(height: 12.h),

          // 2. Travel Dates Input (Date Picker)
          CustomInputField(
            controller: _datesController,
            readOnly: true,
            onTap: _selectDate,
            hintText: AppString.travelDates,
            hintStyle: StyleManager.interRegular13(const Color(0xFF64748B)),
            prefixIcon: Icons.calendar_today_outlined,
            prefixIconColor: const Color(0xFF64748B),
            prefixIconSize: 18.sp,
            borderRadius: 12.r,
            borderColor: const Color(0xFFE2E8F0),
            focusedBorderColor: const Color(0xFFFA8A35),
            height: 48.h,
          ),

          SizedBox(height: 20.h),

          // Search Availability Button
          CustomButton(
            text: AppString.searchAvailability,
            height: 40.h,
            borderRadius: 14.r,
            bgColor: const Color(0xFFFA8A35),
            onTap: () => _onSearch(title),
          ),
        ],
      ),
    );
  }
}
