import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class TicketBoardingPass extends StatelessWidget {
  final String airlineName;
  final String flightClass;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String flightNumber;
  final String date;
  final String departureTime;
  final String boardingTime;
  final String passengerName;
  final String terminal;
  final String gate;
  final String seat;
  final String luggage;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? borderColor;
  final Widget? logoWidget;
  final Color? planeIconColor;
  final Color? airlineLogoColor;
  final Color? economyBgColor;
  final Color? economyTextColor;

  const TicketBoardingPass({
    super.key,
    this.airlineName = 'BRITISH AIRWAYS',
    this.flightClass = 'ECONOMY',
    this.originCode = 'AMS',
    this.originCity = 'AMSTERDAM, NL',
    this.destinationCode = 'FRA',
    this.destinationCity = 'FRANKFURT, DE',
    this.flightNumber = 'BA 0215',
    this.date = '24 Oct, 26',
    this.departureTime = '11:15 AM',
    this.boardingTime = '10:30 AM',
    this.passengerName = 'ALEX RIVERS',
    this.terminal = 'T5',
    this.gate = 'B24',
    this.seat = '14A',
    this.luggage = '03',
    this.primaryColor,
    this.secondaryColor,
    this.borderColor,
    this.logoWidget,
    this.planeIconColor,
    this.airlineLogoColor,
    this.economyBgColor,
    this.economyTextColor,
  });

  static const Color ticketBlue = Color(0xFF0456C8);
  static const Color ticketOrange = Color(0xFFFA7E23);

  @override
  Widget build(BuildContext context) {
    final double notchRadius = 16.r;
    final double cornerRadius = 24.r;

    final double topSectionHeight = 142.h;
    final double middleSectionHeight = 196.h;
    final double bottomSectionHeight = 118.h;
    final double totalHeight =
        topSectionHeight + middleSectionHeight + bottomSectionHeight;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedBorderColor =
        borderColor ??
        (isDark ? Colors.white : AppColors.lightGray.withValues(alpha: 0.7));

    final upperName = airlineName.toUpperCase();
    final bool isLufthansa = upperName.contains('LUFTHANSA');
    final bool isWizz = upperName.contains('WIZZ');

    final Color effectivePrimary = isLufthansa
        ? const Color(0xFFFFFFFF)
        : (isWizz
              ? const Color(0xFFEDE8FF)
              : (primaryColor != null &&
                        primaryColor != const Color(0xFF4C1D95) &&
                        primaryColor != const Color(0xFFBE185D)
                    ? primaryColor!
                    : const Color(0xFF0453BC)));

    final Color effectiveSecondary = isLufthansa
        ? const Color(0xFFFFFFFF)
        : (isWizz
              ? const Color(0xFFE5DEFF)
              : (secondaryColor != null &&
                        secondaryColor != const Color(0xFF3B0764) &&
                        secondaryColor != const Color(0xFF831843)
                    ? secondaryColor!
                    : const Color(0xFF024699)));

    final bool isLight = effectivePrimary.computeLuminance() > 0.45;

    return CustomPaint(
      foregroundPainter: _TicketBorderPainter(
        notchY: topSectionHeight,
        notchRadius: notchRadius,
        cornerRadius: cornerRadius,
        borderColor: resolvedBorderColor,
        borderWidth: 2.2.w,
      ),
      child: ClipPath(
        clipper: _TicketClipper(
          notchY: topSectionHeight,
          notchRadius: notchRadius,
          cornerRadius: cornerRadius,
        ),
        child: SizedBox(
          width: double.infinity,
          height: totalHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: topSectionHeight,
                child: _buildTopSection(
                  topSectionHeight,
                  isLight,
                  effectivePrimary,
                  effectiveSecondary,
                  isLufthansa,
                  isWizz,
                ),
              ),
              SizedBox(
                height: middleSectionHeight,
                child: _buildQrSection(middleSectionHeight, context),
              ),
              SizedBox(
                height: bottomSectionHeight,
                child: _buildBottomSection(
                  bottomSectionHeight,
                  isLight,
                  effectivePrimary,
                  isLufthansa,
                  isWizz,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(
    double height,
    bool isLight,
    Color bgPrimary,
    Color bgSecondary,
    bool isLufthansa,
    bool isWizz,
  ) {
    final textColor = isLight ? const Color(0xFF0F172A) : Colors.white;
    final secondaryTextColor = isLight
        ? const Color(0xFF64748B)
        : const Color(0xffD3D3D3);
    final subtleTextColor = isLight
        ? const Color(0xFF64748B)
        : Colors.white.withValues(alpha: 0.65);
    final dividerColor = isLight
        ? AppColors.lightGray
        : Colors.white.withValues(alpha: 0.18);
    final flightLineColor = isLight
        ? const Color(0xFFCBD5E1)
        : Colors.white.withValues(alpha: 0.35);
    final planeColor =
        planeIconColor ??
        (isLufthansa
            ? const Color(0xFF0B1B3D)
            : (isWizz ? const Color(0xFF8B5CF6) : ticketOrange));
    final resolvedEconomyBg =
        economyBgColor ??
        (isLufthansa
            ? const Color(0xFFCAD4F8)
            : (isWizz ? const Color(0xFFB4A5F8) : const Color(0xff196CCB)));
    final resolvedEconomyText =
        economyTextColor ??
        (isLufthansa ? const Color(0xFF1E1B4B) : Colors.white);
    final resolvedLogoBg =
        airlineLogoColor ??
        (isLufthansa
            ? const Color(0xFF0B1B3D)
            : (isWizz ? const Color(0xFF9A84F8) : const Color(0xff2563EB)));

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgPrimary, bgSecondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 6.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Airline row
            Row(
              children: [
                logoWidget ??
                    Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: resolvedLogoBg,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Transform.rotate(
                          angle: 0.785398,
                          child: Icon(
                            Icons.flight,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    airlineName,
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: resolvedEconomyBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    flightClass,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: resolvedEconomyText,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            // Origin, Airplane indicator, Destination
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildAirportWidget(
                    code: originCode,
                    city: originCity,
                    isEnd: false,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFlightLine(flightLineColor),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Transform.rotate(
                              angle: 1.5708,
                              child: Icon(
                                Icons.flight,
                                color: planeColor,
                                size: 15.sp,
                              ),
                            ),
                          ),
                          _buildFlightLine(flightLineColor),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        flightNumber,
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildAirportWidget(
                    code: destinationCode,
                    city: destinationCity,
                    isEnd: true,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ),
              ],
            ),

            // Thin divider line
            Container(height: 1, color: dividerColor),

            // Date, Departure, Boarding
            Row(
              children: [
                Expanded(
                  child: _buildColumnInfo(
                    label: 'DATE',
                    value: date,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    labelColor: subtleTextColor,
                    valueColor: textColor,
                  ),
                ),
                _buildVerticalDivider(color: dividerColor),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'DEPARTURE',
                    value: departureTime,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    labelColor: subtleTextColor,
                    valueColor: textColor,
                  ),
                ),
                _buildVerticalDivider(color: dividerColor),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'BOARDING',
                    value: boardingTime,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    labelColor: subtleTextColor,
                    valueColor: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrSection(double height, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: height,
      color: isDark ? const Color(0xff000D2D) : Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomPaint(
              size: Size(double.infinity, 2.h),
              painter: _DashedLinePainter(
                color: isDark ? Colors.white : const Color(0xff0453BC),
                dashWidth: 6.5.w,
                dashSpace: 12.5.w,
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: ClipRect(
                child: SizedBox(
                  height: height - 12.h,
                  child: Transform.translate(
                    offset: Offset(0, -6.h),
                    child: Image.asset(ImageAssets.qrScan, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(
    double height,
    bool isLight,
    Color bgPrimary,
    bool isLufthansa,
    bool isWizz,
  ) {
    final bg = bgPrimary;
    final textColor = isLight ? const Color(0xFF0F172A) : Colors.white;
    final subtleTextColor = isLight
        ? const Color(0xFF64748B)
        : Colors.white.withValues(alpha: 0.65);
    final dividerColor = isLight
        ? AppColors.lightGray
        : Colors.white.withValues(alpha: 0.18);
    final planeColor =
        planeIconColor ??
        (isLufthansa
            ? const Color(0xFF0B1B3D)
            : (isWizz ? const Color(0xFF8B5CF6) : Colors.white));
    final waveColor = isLufthansa
        ? const Color(0xFFDCE7F9)
        : const Color(0xFFDDD6FE);

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        image: isLight
            ? null
            : const DecorationImage(
                image: AssetImage(ImageAssets.ticketBottomBg),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
      ),
      child: Stack(
        children: [
          if (isLight)
            Positioned.fill(
              child: CustomPaint(
                painter: _BottomWavesPainter(waveColor: waveColor),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 6.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Passenger Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'PASSENGER',
                      style: GoogleFonts.inter(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w600,
                        color: subtleTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      passengerName,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Divider line
                Container(height: 1, color: dividerColor),

                // Terminal, Gate, Seat, Luggage
                Row(
                  children: [
                    Expanded(
                      child: _buildColumnInfo(
                        label: 'TERMINAL',
                        value: terminal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        isCompact: true,
                        labelColor: subtleTextColor,
                        valueColor: textColor,
                      ),
                    ),
                    _buildVerticalDivider(height: 15.h, color: dividerColor),
                    Expanded(
                      child: _buildColumnInfo(
                        label: 'GATE',
                        value: gate,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        isCompact: true,
                        labelColor: subtleTextColor,
                        valueColor: textColor,
                      ),
                    ),
                    _buildVerticalDivider(height: 15.h, color: dividerColor),
                    Expanded(
                      child: _buildColumnInfo(
                        label: 'SEAT',
                        value: seat,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        isCompact: true,
                        labelColor: subtleTextColor,
                        valueColor: textColor,
                      ),
                    ),
                    _buildVerticalDivider(height: 15.h, color: dividerColor),
                    Expanded(
                      child: _buildColumnInfo(
                        label: 'LUGGAGE',
                        value: luggage,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        isCompact: true,
                        labelColor: subtleTextColor,
                        valueColor: textColor,
                      ),
                    ),
                  ],
                ),

                // Slogan & Airplane
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GOOD TRAVELS A BRIGHTER TOMORROW',
                      style: GoogleFonts.inter(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.w600,
                        color: subtleTextColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    Transform.rotate(
                      angle: 0.785398,
                      child: Icon(Icons.flight, color: planeColor, size: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirportWidget({
    required String code,
    required String city,
    bool isEnd = false,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    String displayCity = city;
    if (displayCity.toUpperCase() == 'AMSTERDAM, NETHERLANDS' ||
        displayCity.toUpperCase() == 'AMSTERDAM') {
      displayCity = 'AMSTERDAM, NL';
    } else if (displayCity.toUpperCase() == 'FRANKFURT, GERMANY' ||
        displayCity.toUpperCase() == 'FRANKFURT') {
      displayCity = 'FRANKFURT, DE';
    }

    return Column(
      crossAxisAlignment: isEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: GoogleFonts.inter(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            color: textColor,
            height: 1.05,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          displayCity,
          maxLines: 1,
          style: GoogleFonts.inter(
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
            color: secondaryTextColor,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }

  Widget _buildColumnInfo({
    required String label,
    required String value,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool isCompact = false,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: isCompact ? 8.sp : 8.5.sp,
            fontWeight: FontWeight.w600,
            color: labelColor,
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: isCompact ? 1.h : 2.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isCompact ? 12.sp : 12.5.sp,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightLine(Color color) {
    return Container(width: 22.w, height: 1.2, color: color);
  }

  Widget _buildVerticalDivider({double? height, Color? color}) {
    return Container(
      width: 1,
      height: height ?? 22.h,
      color: color ?? Colors.white.withValues(alpha: 0.2),
    );
  }
}

class _BottomWavesPainter extends CustomPainter {
  final Color waveColor;

  const _BottomWavesPainter({required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    // Wave 1
    final path1 = Path();
    path1.moveTo(size.width * 0.45, size.height);
    path1.quadraticBezierTo(
      size.width * 0.72,
      size.height * 0.70,
      size.width,
      size.height * 0.82,
    );
    canvas.drawPath(path1, paint);

    // Wave 2
    final path2 = Path();
    path2.moveTo(size.width * 0.58, size.height);
    path2.quadraticBezierTo(
      size.width * 0.82,
      size.height * 0.52,
      size.width,
      size.height * 0.65,
    );
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant _BottomWavesPainter oldDelegate) =>
      oldDelegate.waveColor != waveColor;
}

Path _getTicketPath(
  Size size,
  double notchY,
  double notchRadius,
  double cornerRadius,
) {
  final path = Path();
  final w = size.width;
  final h = size.height;
  final r = cornerRadius;
  final nr = notchRadius;

  path.moveTo(r, 0);
  path.lineTo(w - r, 0);
  path.arcToPoint(Offset(w, r), radius: Radius.circular(r), clockwise: true);
  path.lineTo(w, notchY - nr);
  path.arcToPoint(
    Offset(w, notchY + nr),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(w, h - r);
  path.arcToPoint(
    Offset(w - r, h),
    radius: Radius.circular(r),
    clockwise: true,
  );
  path.lineTo(r, h);
  path.arcToPoint(
    Offset(0, h - r),
    radius: Radius.circular(r),
    clockwise: true,
  );
  path.lineTo(0, notchY + nr);
  path.arcToPoint(
    Offset(0, notchY - nr),
    radius: Radius.circular(nr),
    clockwise: false,
  );
  path.lineTo(0, r);
  path.arcToPoint(Offset(r, 0), radius: Radius.circular(r), clockwise: true);
  path.close();
  return path;
}

class _TicketClipper extends CustomClipper<Path> {
  final double notchY;
  final double notchRadius;
  final double cornerRadius;

  const _TicketClipper({
    required this.notchY,
    required this.notchRadius,
    required this.cornerRadius,
  });

  @override
  Path getClip(Size size) =>
      _getTicketPath(size, notchY, notchRadius, cornerRadius);

  @override
  bool shouldReclip(covariant _TicketClipper oldClipper) =>
      oldClipper.notchY != notchY ||
      oldClipper.notchRadius != notchRadius ||
      oldClipper.cornerRadius != cornerRadius;
}

class _TicketBorderPainter extends CustomPainter {
  final double notchY;
  final double notchRadius;
  final double cornerRadius;
  final Color borderColor;
  final double borderWidth;

  const _TicketBorderPainter({
    required this.notchY,
    required this.notchRadius,
    required this.cornerRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getTicketPath(size, notchY, notchRadius, cornerRadius);

    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TicketBorderPainter oldDelegate) =>
      oldDelegate.notchY != notchY ||
      oldDelegate.notchRadius != notchRadius ||
      oldDelegate.cornerRadius != cornerRadius ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth;
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final StrokeCap strokeCap;

  const _DashedLinePainter({
    required this.color,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    this.strokeCap = StrokeCap.round,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) => false;
}
