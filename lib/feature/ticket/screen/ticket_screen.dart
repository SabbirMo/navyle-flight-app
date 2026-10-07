import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/widgets/custom_button.dart';
import 'package:navyla_flight_app/feature/auth/create_account/widget/back_button.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/navbar/provider/navbar_notifier.dart';
import 'package:navyla_flight_app/feature/ticket/widget/delete_ticket_bottom_sheet.dart';
import 'package:navyla_flight_app/feature/ticket/widget/ticket_boarding_pass.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class TicketScreen extends ConsumerWidget {
  const TicketScreen({super.key});

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    final journey = ref.read(flightJourneyNotifierProvider);

    DeleteTicketBottomSheet.show(
      context,
      flightNumber: journey.flightNumber,
      originCode: journey.originCode,
      destinationCode: journey.destinationCode,
      onDelete: () {
        ref.read(flightJourneyNotifierProvider.notifier).removeBoardingPass();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final journey = ref.watch(flightJourneyNotifierProvider);
    final hasPass = journey.hasActiveFlight;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // Top Bar with Centered 'TICKET' Title and Optional Delete Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          'TICKET',
                          style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E293B),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      if (hasPass)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomBackButton(
                            size: 38.w,
                            onTap: () {
                              ref
                                  .read(navbarNotifierProvider.notifier)
                                  .setIndex(0);
                            },
                          ),
                        ),
                      if (hasPass)
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => _showDeleteConfirmation(context, ref),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFECEB),
                              ),
                              child: Center(
                                child: Image.asset(
                                  ImageAssets.delete,
                                  width: 17.w,
                                  height: 17.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Content: Either Ticket Boarding Pass OR Empty State
                Expanded(
                  child: hasPass
                      ? Align(
                          alignment: const Alignment(0, -0.8),
                          child: TicketBoardingPass(
                            flightNumber: journey.flightNumber,
                            originCode: journey.originCode,
                            destinationCode: journey.destinationCode,
                            originCity: 'AMSTERDAM, NL',
                            destinationCity: 'FRANKFURT, DE',
                            terminal: journey.terminal,
                            gate: journey.gate,
                            seat: journey.seat,
                          ),
                        )
                      : Center(
                          child: _buildEmptyTicketState(context),
                        ),
                ),

                // Bottom spacing for floating navigation bar
                SizedBox(height: 74.h + bottomInset),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyTicketState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF2E6),
            ),
            child: Center(
              child: Icon(
                Icons.confirmation_number_outlined,
                size: 32.sp,
                color: const Color(0xFFFA7E23),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Active Boarding Pass',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Scan or load your flight ticket to view your live boarding pass, countdown, and real-time gate navigation.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.45,
            ),
          ),
          SizedBox(height: 24.h),
          CustomButton(
            text: 'Scan Boarding Pass',
            prefixIcon: Icons.qr_code_scanner_rounded,
            iconSize: 20.sp,
            height: 48.h,
            borderRadius: 24.r,
            boxShadow: true,
            onTap: () => context.push(AppRouterName.scanScreen),
          ),
        ],
      ),
    );
  }
}
