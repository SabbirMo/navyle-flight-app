import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Active flight card displayed at the top of the Feed screen
/// when a user has added a boarding pass.
class FeedActiveFlightCardWidget extends StatelessWidget {
  final String flightNumber;
  final String originCode;
  final String destinationCode;
  final String flightDate;
  final String terminal;
  final String gate;
  final String status;
  final VoidCallback? onTap;

  const FeedActiveFlightCardWidget({
    super.key,
    required this.flightNumber,
    required this.originCode,
    required this.destinationCode,
    this.flightDate = '24 Sep',
    this.terminal = 'Terminal 1',
    this.gate = 'B24',
    this.status = 'On Time',
    this.onTap,
  });

  String get _formattedTerminal {
    final trimmed = terminal.trim();
    if (trimmed.toLowerCase().startsWith('terminal')) {
      return trimmed;
    }
    final digits = trimmed.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isNotEmpty) {
      return 'Terminal $digits';
    }
    return 'Terminal $trimmed';
  }

  String get _formattedGate {
    final trimmed = gate.trim().toUpperCase();
    if (trimmed.startsWith('GATE')) {
      return trimmed;
    }
    return 'GATE $trimmed';
  }

  String get _formattedDate {
    final trimmed = flightDate.trim();
    if (trimmed.isEmpty) return '24 Sep';

    const months = [
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

    // Already contains a month name (e.g. "24 Sep", "24 September", "Sep 24")
    for (int i = 0; i < months.length; i++) {
      if (trimmed.toLowerCase().contains(months[i].toLowerCase())) {
        final match = RegExp(r'(\d{1,2})\s*([A-Za-z]+)').firstMatch(trimmed);
        if (match != null) {
          final day = match.group(1);
          final mStr = match.group(2)!;
          final matchedMonth = months.firstWhere(
            (m) => mStr.toLowerCase().startsWith(m.toLowerCase()),
            orElse: () => months[i],
          );
          return '$day $matchedMonth';
        }
        return trimmed;
      }
    }

    // Handles numeric date strings like "24/09/26", "24/09/2026", "2026-09-24"
    final parts = trimmed.split(RegExp(r'[/.-]'));
    if (parts.length >= 2) {
      if (parts[0].length == 4) {
        // YYYY-MM-DD
        final month = int.tryParse(parts[1]);
        final day = parts.length > 2 ? int.tryParse(parts[2]) : null;
        if (month != null && day != null && month >= 1 && month <= 12) {
          return '$day ${months[month - 1]}';
        }
      } else {
        // DD/MM/YY or DD/MM/YYYY
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        if (day != null && month != null && month >= 1 && month <= 12) {
          return '$day ${months[month - 1]}';
        }
      }
    }

    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFFFEDD5), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFA7E23).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Left: Orange circular icon with 45-degree angled airplane
            Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFFFA7E23),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Transform.rotate(
                  angle: 45 * (math.pi / 180),
                  child: Icon(
                    Icons.flight_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // 2. Middle: Flight info and route
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flight number • Origin → Destination
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          flightNumber,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        '•',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        originCode,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 13.sp,
                        color: const Color(0xFFFA7E23),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        destinationCode,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Date · Terminal
                  Text(
                    '$_formattedDate · $_formattedTerminal',
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // 3. Right: Gate pill badge & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gate Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8EE),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xFF86EFAC).withValues(alpha: 0.5),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5.5.w,
                        height: 5.5.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        _formattedGate,
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // Status text (e.g. "On Time")
                Text(
                  status,
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
