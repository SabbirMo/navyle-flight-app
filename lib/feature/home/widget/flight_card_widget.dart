import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';
import 'package:navyla_flight_app/core/style_manager/style_manager.dart';

/// Scope that automatically provides the responsive scale factor to child widgets
class FlightCardScope extends InheritedWidget {
  final double scale;

  const FlightCardScope({super.key, required this.scale, required super.child});

  static double of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<FlightCardScope>()
            ?.scale ??
        1.0;
  }

  @override
  bool updateShouldNotify(covariant FlightCardScope oldWidget) =>
      scale != oldWidget.scale;
}

/// ============================================================================
/// FLIGHT WAVE CARD CONTAINER (High Performance & Modular)
/// ============================================================================
/// Performance optimizations:
/// 1. [RepaintBoundary]: Isolates GPU layer; stops repainting when parent scrolls.
/// 2. [_PathCache]: Reuses cached [Path]; eliminates 14 Bezier/line allocations per frame.
/// 3. [_WaveBorder]: Reuses persistent [Paint] instance.
/// 4. [FilterQuality.low]: Optimizes GPU texture sampling for background image.
/// 5. [FlightCardScope]: Provides O(1) responsive scale to child widgets.
/// 6. Fully customizable: Pass custom [child] with [Row]/[Column], or edit values directly!
class FlightWaveCard extends StatelessWidget {
  final Widget? child;
  final Widget? statusBadge;
  final String status;
  final String departureTitle;
  final String departureTime;
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String terminal;
  final String checkInTime;
  final String checkInSuffix;
  final String gate;
  final String seat;
  final double? topPadding;
  final EdgeInsetsGeometry? padding;

  const FlightWaveCard({
    super.key,
    this.child,
    this.statusBadge,
    this.status = 'On Time',
    this.topPadding,
    this.departureTitle = 'DEPARTURE IN',
    this.departureTime = '04:42:15',
    this.flightNumber = 'BA 0215',
    this.originCode = 'AMS',
    this.originCity = 'AMSTERDAM',
    this.destinationCode = 'FRA',
    this.destinationCity = 'FRANKFURT',
    this.terminal = 'T5',
    this.checkInTime = '8:00',
    this.checkInSuffix = 'am',
    this.gate = 'B24',
    this.seat = '14A',
    this.padding,
  });

  static const double designWidth = 800;
  static const double designHeight = 500;

  @override
  Widget build(BuildContext context) {
    final palette = _CardPalette.of(context);

    return RepaintBoundary(
      child: AspectRatio(
        aspectRatio: designWidth / designHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final scale = constraints.maxWidth / designWidth;
            double s(double value) => value * scale;

            return MediaQuery.withClampedTextScaling(
              maxScaleFactor: 1.0,
              child: FlightCardScope(
                scale: scale,
                child: Stack(
                  children: [
                    // 1. Top-right Tab behind the wave
                    Positioned(
                      left: s(468),
                      top: s(16),
                      width: s(318),
                      height: s(146),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: palette.tab,
                          border: Border.all(
                            color: palette.stroke,
                            width: s(3.5),
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(s(42)),
                          ),
                        ),
                      ),
                    ),

                    // 2. Status Badge in the top-right tab area
                    Positioned(
                      left: s(604),
                      top: s(43),
                      child:
                          statusBadge ??
                          FlightStatusBadge(
                            status: status,
                            scale: scale,
                            color: palette.lime,
                          ),
                    ),

                    // 3. Clipped Wave Body (Background Image + Scrim Gradients + Content)
                    Positioned.fill(
                      child: ClipPath(
                        clipper: const _WaveClipper(),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              ImageAssets.homeAir,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              filterQuality: FilterQuality.low,
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: palette.scrim,
                              ),
                            ),
                            if (palette.secondaryScrim != null)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: palette.secondaryScrim,
                                ),
                              ),
                            // Content slot (User's custom child or default Row/Column layout)
                            Padding(
                              padding:
                                  padding ??
                                  EdgeInsets.fromLTRB(
                                    s(36),
                                    s(28),
                                    s(36),
                                    s(18),
                                  ),
                              child:
                                  child ??
                                  FlightCardDefaultContent(
                                    scale: scale,
                                    departureTitle: departureTitle,
                                    departureTime: departureTime,
                                    flightNumber: flightNumber,
                                    originCode: originCode,
                                    originCity: originCity,
                                    destinationCode: destinationCode,
                                    destinationCity: destinationCity,
                                    terminal: terminal,
                                    checkInTime: checkInTime,
                                    checkInSuffix: checkInSuffix,
                                    gate: gate,
                                    seat: seat,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 4. White Wave Border Stroke
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _WaveBorder(
                            color: palette.stroke,
                            strokeWidth: s(3.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 1: DEPARTURE COUNTDOWN WIDGET
/// ============================================================================
/// Renders the "DEPARTURE IN" heading and "04:42:15" countdown timer.
class FlightCountdownWidget extends StatelessWidget {
  final String title;
  final String time;
  final double? scale;
  final Color? titleColor;
  final Color? timeColor;
  final TextStyle? titleStyle;
  final TextStyle? timeStyle;
  final CrossAxisAlignment crossAxisAlignment;

  const FlightCountdownWidget({
    super.key,
    this.title = 'DEPARTURE IN',
    this.time = '04:42:15',
    this.scale,
    this.titleColor,
    this.timeColor,
    this.titleStyle,
    this.timeStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTimeColor = timeColor ?? AppColors.white;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ?? StyleManager.interSemiBold14(AppColors.white),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleManager.sfProBold30(
              effectiveTimeColor,
            ).copyWith(fontSize: 28.sp),
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 2: FLIGHT NUMBER WIDGET
/// ============================================================================
/// Renders flight number like "BA 0215".
class FlightNumberWidget extends StatelessWidget {
  final String flightNumber;
  final double? scale;
  final Color? color;
  final TextStyle? style;

  const FlightNumberWidget({
    super.key,
    this.flightNumber = 'BA 0215',
    this.scale,
    this.color,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        flightNumber,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: StyleManager.interRegular13(AppColors.white),
      ),
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 3: AIRPORT CODE & CITY WIDGET
/// ============================================================================
/// Renders airport code (e.g. "AMS" / "FRA") and city name (e.g. "AMSTERDAM").
class FlightAirportWidget extends StatelessWidget {
  final String code;
  final String city;
  final bool isDestination;
  final double? scale;
  final Color? codeColor;
  final Color? cityColor;
  final TextStyle? codeStyle;
  final TextStyle? cityStyle;

  const FlightAirportWidget({
    super.key,
    required this.code,
    required this.city,
    this.isDestination = false,
    this.scale,
    this.codeColor,
    this.cityColor,
    this.codeStyle,
    this.cityStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isDestination
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleManager.sfProBold24(
              AppColors.white,
            ).copyWith(fontSize: 28.sp),
          ),
        ),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            city.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: StyleManager.interSemiBold12(
              AppColors.white,
            ).copyWith(fontSize: 8.sp),
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 4: FLIGHT PATH INDICATOR (Airplane icon + connecting lines)
/// ============================================================================
class FlightPathIndicator extends StatelessWidget {
  final double? scale;
  final Color? iconColor;
  final Color? lineColor;
  final IconData icon;

  const FlightPathIndicator({
    super.key,
    this.scale,
    this.iconColor,
    this.lineColor,
    this.icon = Icons.flight,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);
    final planeColor = iconColor ?? palette.primary;
    final line = lineColor ?? palette.rule;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0 * s),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showLines = constraints.maxWidth > (30.0 * s);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showLines)
                Expanded(
                  child: Container(height: 2.0 * s, color: line),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0 * s),
                child: Transform.rotate(
                  angle: math.pi / 2,
                  child: Icon(icon, color: planeColor, size: 52.0 * s),
                ),
              ),
              if (showLines)
                Expanded(
                  child: Container(height: 2.0 * s, color: line),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 5: FULL FLIGHT ROUTE WIDGET
/// ============================================================================
/// Combines flight number + origin airport + flight path + destination airport.
class FlightRouteWidget extends StatelessWidget {
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final double? scale;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? lineColor;

  const FlightRouteWidget({
    super.key,
    this.flightNumber = 'BA 0215',
    this.originCode = 'AMS',
    this.originCity = 'AMSTERDAM',
    this.destinationCode = 'FRA',
    this.destinationCity = 'FRANKFURT',
    this.scale,
    this.primaryColor,
    this.secondaryColor,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FlightNumberWidget(
          flightNumber: flightNumber,
          scale: s,
          color: primaryColor,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: FlightAirportWidget(
                code: originCode,
                city: originCity,
                scale: s,
                codeColor: primaryColor,
                cityColor: secondaryColor,
              ),
            ),
            Expanded(
              flex: 4,
              child: FlightPathIndicator(
                scale: s,
                iconColor: primaryColor,
                lineColor: lineColor,
              ),
            ),
            Flexible(
              flex: 3,
              child: FlightAirportWidget(
                code: destinationCode,
                city: destinationCity,
                isDestination: true,
                scale: s,
                codeColor: primaryColor,
                cityColor: secondaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 6: HORIZONTAL DIVIDER
/// ============================================================================
class FlightHorizontalDivider extends StatelessWidget {
  final double? scale;
  final Color? color;
  final double height;

  const FlightHorizontalDivider({
    super.key,
    this.scale,
    this.color,
    this.height = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);

    return Container(height: height * s, color: color ?? palette.rule);
  }
}

/// ============================================================================
/// MODULAR WIDGET 7: VERTICAL DIVIDER
/// ============================================================================
class FlightVerticalDivider extends StatelessWidget {
  final double? scale;
  final Color? color;
  final double width;
  final double height;

  const FlightVerticalDivider({
    super.key,
    this.scale,
    this.color,
    this.width = 1.5,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);

    return Container(
      width: width * s,
      height: height * s,
      color: color ?? palette.rule,
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 8: FLIGHT INFO ITEM (TERMINAL, CHECK IN, GATE, SEAT)
/// ============================================================================
/// Renders heading (e.g. "TERMINAL"), value (e.g. "T5"), and optional suffix ("am").
class FlightInfoItem extends StatelessWidget {
  final String title;
  final String value;
  final String? suffix;
  final double? scale;
  final Color? titleColor;
  final Color? valueColor;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final CrossAxisAlignment crossAxisAlignment;

  const FlightInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.suffix,
    this.scale,
    this.titleColor,
    this.valueColor,
    this.titleStyle,
    this.valueStyle,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);
    final headingColor = titleColor ?? palette.secondary;
    final contentColor = valueColor ?? palette.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                titleStyle ??
                TextStyle(
                  color: headingColor,
                  fontSize: 23.0 * s,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                ),
          ),
        ),
        SizedBox(height: 8.0 * s),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            maxLines: 1,
            text: TextSpan(
              style:
                  valueStyle ??
                  TextStyle(
                    color: contentColor,
                    fontSize: 34.0 * s,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
              children: [
                TextSpan(text: value),
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: TextStyle(fontSize: 16.0 * s),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 9: BOTTOM INFO ROW
/// ============================================================================
/// Horizontal Row displaying info items separated by vertical divider lines.
class FlightBottomInfoRow extends StatelessWidget {
  final List<Widget> items;
  final double? scale;
  final Color? dividerColor;
  final double dividerHeight;

  const FlightBottomInfoRow({
    super.key,
    required this.items,
    this.scale,
    this.dividerColor,
    this.dividerHeight = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);
    final divColor = dividerColor ?? palette.rule;

    final rowChildren = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      rowChildren.add(Expanded(child: items[i]));
      if (i < items.length - 1) {
        rowChildren.add(
          FlightVerticalDivider(
            scale: s,
            color: divColor,
            height: dividerHeight,
          ),
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );
  }
}

/// ============================================================================
/// MODULAR WIDGET 10: STATUS BADGE (Glowing lime dot + 'On Time')
/// ============================================================================
class FlightStatusBadge extends StatelessWidget {
  final String status;
  final double? scale;
  final Color? color;
  final double dotSize;
  final double fontSize;

  const FlightStatusBadge({
    super.key,
    this.status = 'On Time',
    this.scale,
    this.color,
    this.dotSize = 16.0,
    this.fontSize = 29.0,
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);
    final palette = _CardPalette.of(context);
    final dotColor = color ?? palette.lime;
    final dSize = dotSize * s;
    final fSize = fontSize * s;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: dSize,
            height: dSize,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.55),
                  blurRadius: 15 * s,
                  spreadRadius: 3 * s,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.0 * s),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fSize,
              fontWeight: FontWeight.w800,
              color: dotColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// ============================================================================
/// OPTIONAL DEFAULT CONTENT PRESET (Clean Row and Column Composition)
/// ============================================================================
/// Pre-assembled layout built using pure Row and Column widgets.
class FlightCardDefaultContent extends StatelessWidget {
  final double? scale;
  final String departureTitle;
  final String departureTime;
  final String flightNumber;
  final String originCode;
  final String originCity;
  final String destinationCode;
  final String destinationCity;
  final String terminal;
  final String checkInTime;
  final String checkInSuffix;
  final String gate;
  final String seat;

  const FlightCardDefaultContent({
    super.key,
    this.scale,
    this.departureTitle = 'DEPARTURE IN',
    this.departureTime = '04:42:15',
    this.flightNumber = 'BA 0215',
    this.originCode = 'AMS',
    this.originCity = 'AMSTERDAM',
    this.destinationCode = 'FRA',
    this.destinationCity = 'FRANKFURT',
    this.terminal = 'T5',
    this.checkInTime = '8:00',
    this.checkInSuffix = 'am',
    this.gate = 'B24',
    this.seat = '14A',
  });

  @override
  Widget build(BuildContext context) {
    final s = scale ?? FlightCardScope.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top: Countdown
            FlightCountdownWidget(
              scale: s,
              title: departureTitle,
              time: departureTime,
            ),
            SizedBox(height: 10.0 * s),

            // Middle: Route Row
            FlightRouteWidget(
              scale: s,
              flightNumber: flightNumber,
              originCode: originCode,
              originCity: originCity,
              destinationCode: destinationCode,
              destinationCity: destinationCity,
            ),
            SizedBox(height: 24.0 * s),

            // Divider
            FlightHorizontalDivider(scale: s),
            SizedBox(height: 16.0 * s),

            // Bottom: Info Row with 4 columns
            FlightBottomInfoRow(
              scale: s,
              items: [
                FlightInfoItem(title: 'TERMINAL', value: terminal),
                FlightInfoItem(
                  title: 'CHECK IN',
                  value: checkInTime,
                  suffix: checkInSuffix,
                ),
                FlightInfoItem(title: 'GATE', value: gate),
                FlightInfoItem(title: 'SEAT', value: seat),
              ],
            ),
          ],
        );

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topLeft,
            child: SizedBox(width: constraints.maxWidth, child: content),
          ),
        );
      },
    );
  }
}

/// ============================================================================
/// INTERNALS: PATH CACHING, CLIPPER, PAINTER, AND PALETTE
/// ============================================================================
class _PathCache {
  static double _lastW = 0;
  static double _lastH = 0;
  static Path? _cachedWavePath;

  static Path getWavePath(Size size) {
    if (_cachedWavePath != null &&
        _lastW == size.width &&
        _lastH == size.height) {
      return _cachedWavePath!;
    }
    _lastW = size.width;
    _lastH = size.height;
    _cachedWavePath = _generateWavePath(size);
    return _cachedWavePath!;
  }

  static Path _generateWavePath(Size size) {
    final w = size.width;
    final h = size.height;
    double x(double val) => val * w / 800;
    double y(double val) => val * h / 493;

    return Path()
      ..moveTo(x(39), 0)
      ..lineTo(x(428), 0)
      ..cubicTo(x(480), 0, x(491), y(40), x(530), y(72))
      ..cubicTo(x(568), y(100), x(630), y(105), x(678), y(105))
      ..lineTo(x(740), y(105))
      ..cubicTo(x(775), y(105), x(800), y(126), x(800), y(160))
      ..lineTo(x(800), y(443))
      ..cubicTo(x(800), y(473), x(776), y(493), x(747), y(493))
      ..lineTo(x(31), y(493))
      ..cubicTo(x(13), y(493), 0, y(480), 0, y(462))
      ..lineTo(0, y(39))
      ..cubicTo(0, y(17), x(17), 0, x(39), 0)
      ..close();
  }
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) => _PathCache.getWavePath(size);

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) => false;
}

class _WaveBorder extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final Paint _paint;

  _WaveBorder({required this.color, required this.strokeWidth})
    : _paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..color = color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(_PathCache.getWavePath(size), _paint);
  }

  @override
  bool shouldRepaint(covariant _WaveBorder oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}

class _CardPalette {
  const _CardPalette({
    required this.tab,
    required this.stroke,
    required this.primary,
    required this.secondary,
    required this.rule,
    required this.lime,
    required this.scrim,
    this.secondaryScrim,
  });

  final Gradient tab;
  final Color stroke;
  final Color primary;
  final Color secondary;
  final Color rule;
  final Color lime;
  final Gradient scrim;
  final Gradient? secondaryScrim;

  static _CardPalette of(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return const _CardPalette(
        tab: LinearGradient(colors: [Color(0xFF422F26), Color(0xFF422F26)]),
        stroke: Color(0xFFF4F7FB),
        primary: Color(0xFFFFFFFF),
        secondary: Color(0xFFF2CEAE),
        rule: Color(0x66FFFFFF),
        lime: Color(0xFFA3E635),
        scrim: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xDEC25211), Color(0xC4AB450E), Color(0xF26D2405)],
          stops: [0.0, 0.50, 1.0],
        ),
      );
    }
    return const _CardPalette(
      tab: AppColors.bedgeGradient,
      stroke: Color(0xFFF4F7FB),
      primary: Color(0xFFFFFFFF),
      secondary: Color(0xFFDAE1ED),
      rule: Color(0xB4FFFFFF),
      lime: Color(0xFFD0FF2D),
      scrim: AppColors.homeAirBottomGradient,
      secondaryScrim: AppColors.homeAirLeftGradient,
    );
  }
}
