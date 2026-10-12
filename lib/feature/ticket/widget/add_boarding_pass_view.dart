import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navyla_flight_app/feature/home/provider/flight_journey_notifier.dart';
import 'package:navyla_flight_app/feature/ticket/model/saved_ticket_model.dart';
import 'package:navyla_flight_app/feature/ticket/provider/saved_tickets_provider.dart';
import 'package:navyla_flight_app/router/app_router_name.dart';

class AddBoardingPassView extends ConsumerWidget {
  final VoidCallback? onBackToTicket;

  const AddBoardingPassView({super.key, this.onBackToTicket});

  void _selectTicket(
    BuildContext context,
    WidgetRef ref,
    int index,
    SavedTicketModel ticket,
  ) {
    ref.read(savedTicketsProvider.notifier).selectTicket(index);
    ref
        .read(flightJourneyNotifierProvider.notifier)
        .addBoardingPass(
          flightNumber: ticket.flightNumber,
          originCode: ticket.originCode,
          originCity: ticket.originCity,
          destinationCode: ticket.destinationCode,
          destinationCity: ticket.destinationCity,
          departureCountdown: '04:42:15',
          seat: ticket.seat,
          gate: ticket.gate,
          terminal: ticket.terminal,
          flightDate: ticket.displayDate,
        );
    onBackToTicket?.call();
  }

  void _handleManualEntry(BuildContext context, WidgetRef ref) {
    context.push(AppRouterName.verifyDetailsScreen, extra: {'isManual': true});
  }

  Future<void> _handleGalleryUpload(BuildContext context, WidgetRef ref) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && context.mounted) {
        context.push(AppRouterName.reviewScanScreen, extra: pickedFile.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gallery pick failed: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsState = ref.watch(savedTicketsProvider);
    final tickets = ticketsState.tickets;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 4.h),

            // Top Bar: Centered 'ADD BOARDING PASS' with circular 3-dots button on right
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Text(
                      'ADD BOARDING PASS',
                      style: GoogleFonts.inter(
                        fontSize: 17.5.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  if (onBackToTicket != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: onBackToTicket,
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF0F1A30)
                                : Colors.white,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : const Color(0xFFE2E8F0),
                              width: 1.1,
                            ),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        cardColor: isDark
                            ? const Color(0xFF0F1A30)
                            : Colors.white,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: PopupMenuButton<String>(
                        tooltip: '',
                        position: PopupMenuPosition.under,
                        offset: Offset(0, 6.h),
                        color: isDark ? const Color(0xFF0B1428) : Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : const Color(0xFFE2E8F0),
                            width: 1.1,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'demo') {
                            ref
                                .read(savedTicketsProvider.notifier)
                                .loadDemoTickets();
                            final first = SavedTicketModel.defaultTickets.first;
                            ref
                                .read(flightJourneyNotifierProvider.notifier)
                                .addBoardingPass(
                                  flightNumber: first.flightNumber,
                                  originCode: first.originCode,
                                  originCity: first.originCity,
                                  destinationCode: first.destinationCode,
                                  destinationCity: first.destinationCity,
                                  terminal: first.terminal,
                                  gate: first.gate,
                                  seat: first.seat,
                                  flightDate: first.displayDate,
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Loaded 3 sample tickets for demonstration',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF0B1428),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else if (value == 'clear') {
                            ref.read(savedTicketsProvider.notifier).removeAll();
                            ref
                                .read(flightJourneyNotifierProvider.notifier)
                                .removeBoardingPass();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Saved tickets cleared',
                                  style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF0B1428),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'demo',
                            height: 44.h,
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.airplane_ticket_outlined,
                                  color: const Color(0xFF38BDF8),
                                  size: 19.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Load Demo Tickets (3)',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'clear',
                            height: 44.h,
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  color: const Color(0xFFEF4444),
                                  size: 19.sp,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Clear Saved Tickets',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFEF4444),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF0F1A30)
                                : Colors.white,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : const Color(0xFFE2E8F0),
                              width: 1.1,
                            ),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.more_vert,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            // Dashed Scanner Card: SCAN YOUR BOARDING PASS
            CustomPaint(
              painter: DashedRoundedBorderPainter(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.28)
                    : const Color(0xFFCBD5E1),
                strokeWidth: 1.2,
                radius: 20.r,
                dashLength: 5.5,
                gapLength: 4.5,
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF041028) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.35 : 0.05,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    // Reticle scanner icon
                    ScannerReticleIcon(
                      width: 44.w,
                      height: 34.h,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'SCAN YOUR BOARDING PASS',
                      style: GoogleFonts.inter(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'ALIGN THE QR CODE WITHIN THE FRAME',
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    // 'Open Camera' button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => context.push(AppRouterName.scanScreen),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          width: double.infinity,
                          height: 46.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFA7E23), Color(0xFFFF942B)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFFA7E23,
                                ).withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_open_rounded,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Open Camera',
                                style: GoogleFonts.inter(
                                  fontSize: 14.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // OR divider
            _buildOrDivider(isDark),

            // 'Upload from Gallery' button
            _buildOutlinedButton(
              icon: Icons.photo_outlined,
              text: 'Upload from Gallery',
              isDark: isDark,
              onTap: () => _handleGalleryUpload(context, ref),
            ),

            // OR divider
            _buildOrDivider(isDark),

            // 'Enter Details Manually' button
            _buildOutlinedButton(
              icon: Icons.keyboard_alt_outlined,
              text: 'Enter Details Manually',
              isDark: isDark,
              onTap: () => _handleManualEntry(context, ref),
            ),

            SizedBox(height: 18.h),

            // 'Your saved tickets (N)' Header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your saved tickets (${tickets.length})',
                style: GoogleFonts.inter(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  letterSpacing: 0.2,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // Card with list of saved tickets
            if (tickets.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF041028) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.18)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.35 : 0.06,
                      ),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.airplane_ticket_outlined,
                        size: 36.sp,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.45)
                            : const Color(0xFF94A3B8),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'No saved tickets yet',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Scan or enter details to add your first flight',
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.6)
                              : const Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF041028) : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.18)
                        : const Color(0xFFE2E8F0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.35 : 0.08,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(tickets.length, (index) {
                    final ticket = tickets[index];
                    final isLast = index == tickets.length - 1;
                    return Column(
                      children: [
                        _buildTicketTile(
                          ticket: ticket,
                          isDark: isDark,
                          onTap: () =>
                              _selectTicket(context, ref, index, ticket),
                        ),
                        if (!isLast)
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : const Color(0xFFF1F5F9),
                            indent: 14.w,
                            endIndent: 14.w,
                          ),
                      ],
                    );
                  }),
                ),
              ),

            SizedBox(height: 120.h + bottomInset),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketTile({
    required SavedTicketModel ticket,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Airline Circle Avatar
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ticket.badgeColor,
                ),
                child: Center(child: _buildBadgeIcon(ticket)),
              ),
              SizedBox(width: 12.w),
              // Ticket details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          ticket.flightNumber,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            '${ticket.originCode}  →  ${ticket.destinationCode}',
                            style: GoogleFonts.inter(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.75)
                                  : const Color(0xFF64748B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      '${ticket.displayDate}, ${ticket.departureTime}',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.55)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Chevron icon
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : const Color(0xFF94A3B8),
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(SavedTicketModel ticket) {
    if (ticket.badgeType == 'flight') {
      return Transform.rotate(
        angle: 0.785,
        child: Icon(Icons.flight, color: Colors.white, size: 20.sp),
      );
    } else if (ticket.badgeType == 'compass') {
      return Icon(Icons.explore_outlined, color: Colors.white, size: 20.sp);
    } else if (ticket.badgeType == 'wizz') {
      return Text(
        'wizz',
        style: GoogleFonts.inter(
          fontSize: 9.sp,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      );
    }
    return Icon(Icons.flight, color: Colors.white, size: 20.sp);
  }

  Widget _buildOrDivider(bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 11.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFCBD5E1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'OR',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                letterSpacing: 1.0,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : const Color(0xFFCBD5E1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedButton({
    required IconData icon,
    required String text,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF041028) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.28)
                  : const Color(0xFFCBD5E1),
              width: 1.2,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter to draw a reticle viewfinder scanner frame icon
class ScannerReticleIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const ScannerReticleIcon({
    super.key,
    required this.width,
    required this.height,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _ScannerReticlePainter(color: color),
    );
  }
}

class _ScannerReticlePainter extends CustomPainter {
  final Color color;

  _ScannerReticlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final cornerLength = w * 0.24;

    // Top-left
    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);

    // Top-right
    canvas.drawLine(Offset(w, 0), Offset(w - cornerLength, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, cornerLength), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, h), Offset(cornerLength, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - cornerLength), paint);

    // Bottom-right
    canvas.drawLine(Offset(w, h), Offset(w - cornerLength, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - cornerLength), paint);

    // Center horizontal bars: [ -   - ]
    final centerY = h / 2;
    canvas.drawLine(
      Offset(w * 0.20, centerY),
      Offset(w * 0.42, centerY),
      paint,
    );
    canvas.drawLine(
      Offset(w * 0.58, centerY),
      Offset(w * 0.80, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for dashed rounded border
class DashedRoundedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashLength;
  final double gapLength;

  DashedRoundedBorderPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.radius = 20,
    this.dashLength = 5.0,
    this.gapLength = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + dashLength < metric.length)
            ? dashLength
            : metric.length - distance;
        final extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
