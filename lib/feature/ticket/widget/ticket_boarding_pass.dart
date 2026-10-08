import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

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
  });

  static const Color ticketBlue = Color(0xFF0456C8);
  static const Color ticketOrange = Color(0xFFFA7E23);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double notchRadius = 16.r;
    final double cornerRadius = 24.r;

    final double topSectionHeight = 146.h;
    final double middleSectionHeight = 215.h;
    final double bottomSectionHeight = 130.h;
    final double totalHeight =
        topSectionHeight + middleSectionHeight + bottomSectionHeight;

    return CustomPaint(
      painter: _TicketCardPainter(
        notchY: topSectionHeight,
        notchRadius: notchRadius,
        cornerRadius: cornerRadius,
        borderColor: isDark ? Colors.white : ticketBlue,
        borderWidth: 2.w,
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
                child: _buildTopSection(topSectionHeight),
              ),
              SizedBox(
                height: middleSectionHeight,
                child: _buildQrSection(middleSectionHeight, context),
              ),
              SizedBox(
                height: bottomSectionHeight,
                child: _buildBottomSection(bottomSectionHeight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff0453BC), Color(0xff024699)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 8.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Airline row
            Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: const Color(0xff2563EB),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: 1.5708,
                      child: Icon(
                        Icons.flight,
                        color: Colors.white,
                        size: 18.sp,
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
                      color: Colors.white,
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
                    color: const Color(0xff196CCB),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    flightClass,
                    style: StyleManager.interBold10(AppColors.white),
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildFlightLine(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Transform.rotate(
                              angle: 1.5708,
                              child: Icon(
                                Icons.flight,
                                color: ticketOrange,
                                size: 15.sp,
                              ),
                            ),
                          ),
                          _buildFlightLine(),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        flightNumber,
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
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
                  ),
                ),
              ],
            ),

            // Thin divider line
            Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),

            // Date, Departure, Boarding
            Row(
              children: [
                Expanded(
                  child: _buildColumnInfo(
                    label: 'DATE',
                    value: date,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                _buildVerticalDivider(),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'DEPARTURE',
                    value: departureTime,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                _buildVerticalDivider(),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'BOARDING',
                    value: boardingTime,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
      color: isDark ? Color(0xff000D2D) : Colors.white,
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

  Widget _buildBottomSection(double height) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: const BoxDecoration(
        color: ticketBlue,
        image: DecorationImage(
          image: AssetImage(ImageAssets.ticketBottomBg),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(18.w, 6.h, 18.w, 6.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            // Passenger Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PASSENGER',
                  style: GoogleFonts.inter(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.65),
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  passengerName,
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),

            // Divider line
            Container(height: 1, color: Colors.white.withValues(alpha: 0.18)),

            // Terminal, Gate, Seat, Luggage
            Row(
              children: [
                Expanded(
                  child: _buildColumnInfo(
                    label: 'TERMINAL',
                    value: terminal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    isCompact: true,
                  ),
                ),
                _buildVerticalDivider(height: 18.h),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'GATE',
                    value: gate,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    isCompact: true,
                  ),
                ),
                _buildVerticalDivider(height: 18.h),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'SEAT',
                    value: seat,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    isCompact: true,
                  ),
                ),
                _buildVerticalDivider(height: 18.h),
                Expanded(
                  child: _buildColumnInfo(
                    label: 'LUGGAGE',
                    value: luggage,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    isCompact: true,
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
                    color: Colors.white.withValues(alpha: 0.75),
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(width: 6.w),
                Transform.rotate(
                  angle: 0.785398,
                  child: Icon(Icons.flight, color: Colors.white, size: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportWidget({
    required String code,
    required String city,
    bool isEnd = false,
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
            color: Colors.white,
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
            color: const Color(0xffD3D3D3),
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
            color: Colors.white.withValues(alpha: 0.65),
            letterSpacing: 0.7,
          ),
        ),
        SizedBox(height: isCompact ? 1.h : 2.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isCompact ? 12.sp : 12.5.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFlightLine() {
    return Container(
      width: 22.w,
      height: 1.2,
      color: Colors.white.withValues(alpha: 0.35),
    );
  }

  Widget _buildVerticalDivider({double? height}) {
    return Container(
      width: 1,
      height: height ?? 22.h,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }
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

class _TicketCardPainter extends CustomPainter {
  final double notchY;
  final double notchRadius;
  final double cornerRadius;
  final Color borderColor;
  final double borderWidth;

  const _TicketCardPainter({
    required this.notchY,
    required this.notchRadius,
    required this.cornerRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _getTicketPath(size, notchY, notchRadius, cornerRadius);

    // 1. Drop shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);

    // 2. Stroke border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _TicketCardPainter oldDelegate) =>
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
