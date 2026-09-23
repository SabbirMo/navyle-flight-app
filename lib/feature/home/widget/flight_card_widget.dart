import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:navyla_flight_app/core/colors/app_colors.dart';
import 'package:navyla_flight_app/core/image_manager/image_assets.dart';

class FlightWaveCard extends StatelessWidget {
  const FlightWaveCard({super.key});

  static const double designWidth = 800;
  static const double designHeight = 500;

  @override
  Widget build(BuildContext context) {
    final palette = _CardPalette.of(context);

    return AspectRatio(
      aspectRatio: designWidth / designHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final scale = constraints.maxWidth / designWidth;
          double s(double value) => value * scale;

          return Stack(
            children: [
              // Behind the card. Its lower edge disappears under the wave.
              Positioned(
                left: s(468),
                top: s(16),
                width: s(318),
                height: s(146),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.tab,
                    border: Border.all(color: palette.stroke, width: s(3.5)),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(s(42)),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: s(604),
                top: s(50),
                child: Container(
                  width: s(16),
                  height: s(16),
                  decoration: BoxDecoration(
                    color: palette.lime,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: palette.lime.withValues(alpha: 0.55),
                        blurRadius: s(15),
                        spreadRadius: s(3),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: s(636),
                top: s(43),
                child: Text(
                  'On Time',
                  style: TextStyle(
                    fontSize: s(29),
                    height: 1,
                    fontWeight: FontWeight.w800,
                    color: palette.lime,
                  ),
                ),
              ),
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
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(gradient: palette.scrim),
                      ),
                      if (palette.secondaryScrim != null)
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: palette.secondaryScrim,
                          ),
                        ),
                      _CardContent(scale: scale, palette: palette),
                    ],
                  ),
                ),
              ),
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
          );
        },
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent({required this.scale, required this.palette});

  final double scale;
  final _CardPalette palette;

  @override
  Widget build(BuildContext context) {
    double s(double value) => value * scale;
    TextStyle style(
      double size, {
      FontWeight weight = FontWeight.w600,
      Color? color,
    }) => TextStyle(
      fontSize: s(size),
      height: 1,
      fontWeight: weight,
      color: color ?? palette.primary,
    );

    Widget label(
      String text,
      double x,
      double y,
      double size, {
      FontWeight weight = FontWeight.w600,
      Color? color,
    }) => Positioned(
      left: s(x),
      top: s(y),
      child: Text(
        text,
        style: style(size, weight: weight, color: color),
      ),
    );

    Widget rule(double x, double y, double width, {double height = 1.5}) =>
        Positioned(
          left: s(x),
          top: s(y),
          width: s(width),
          height: s(height),
          child: ColoredBox(color: palette.rule),
        );

    return Stack(
      children: [
        label('DEPARTURE IN', 40, 31, 28, weight: FontWeight.w700),
        label('04:42:15', 40, 83, 70, weight: FontWeight.w800),
        label('BA 0215', 40, 187, 29, weight: FontWeight.w500),
        label('AMS', 40, 235, 58, weight: FontWeight.w800),
        label('AMSTERDAM', 40, 306, 20, weight: FontWeight.w700),
        Positioned(
          right: s(40),
          top: s(235),
          child: Text('FRA', style: style(58, weight: FontWeight.w800)),
        ),
        Positioned(
          right: s(40),
          top: s(306),
          child: Text('FRANKFURT', style: style(20, weight: FontWeight.w700)),
        ),
        rule(283, 280, 87, height: 2),
        rule(431, 280, 77, height: 2),
        Positioned(
          left: s(371),
          top: s(258),
          child: Transform.rotate(
            angle: math.pi / 2,
            child: Icon(Icons.flight, color: palette.primary, size: s(52)),
          ),
        ),
        rule(40, 354, 720, height: 2),
        rule(227, 389, 1.5, height: 60),
        rule(424, 389, 1.5, height: 60),
        rule(653, 389, 1.5, height: 60),
        _infoColumn('TERMINAL', 'T5', 40, 183, scale, palette),
        _infoColumn('CHECK IN', '8:00', 229, 193, scale, palette, suffix: 'am'),
        _infoColumn('GATE', 'B24', 428, 222, scale, palette),
        _infoColumn('SEAT', '14A', 657, 103, scale, palette),
      ],
    );
  }

  static Widget _infoColumn(
    String heading,
    String value,
    double left,
    double width,
    double scale,
    _CardPalette palette, {
    String? suffix,
  }) {
    double s(double value) => value * scale;
    return Positioned(
      left: s(left),
      top: s(375),
      width: s(width),
      child: Column(
        children: [
          Text(
            heading,
            maxLines: 1,
            style: TextStyle(
              color: palette.secondary,
              fontSize: s(23),
              fontWeight: FontWeight.w600,
              height: 1.15,
            ),
          ),
          SizedBox(height: s(14)),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: palette.primary,
                fontSize: s(34),
                fontWeight: FontWeight.w800,
                height: 1,
              ),
              children: [
                TextSpan(text: value),
                if (suffix != null)
                  TextSpan(
                    text: suffix,
                    style: TextStyle(fontSize: s(16)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Path _wavePath(Size size) {
  double x(double value) => value * size.width / 800;
  double y(double value) => value * size.height / 493;

  return Path()
    ..moveTo(x(39), y(0))
    ..lineTo(x(428), y(0))
    ..cubicTo(x(480), y(0), x(491), y(40), x(530), y(72))
    ..cubicTo(x(568), y(100), x(630), y(105), x(678), y(105))
    ..lineTo(x(740), y(105))
    ..cubicTo(x(775), y(105), x(800), y(126), x(800), y(160))
    ..lineTo(x(800), y(443))
    ..cubicTo(x(800), y(473), x(776), y(493), x(747), y(493))
    ..lineTo(x(31), y(493))
    ..cubicTo(x(13), y(493), x(0), y(480), x(0), y(462))
    ..lineTo(x(0), y(39))
    ..cubicTo(x(0), y(17), x(17), y(0), x(39), y(0))
    ..close();
}

class _WaveClipper extends CustomClipper<Path> {
  const _WaveClipper();

  @override
  Path getClip(Size size) => _wavePath(size);

  @override
  bool shouldReclip(covariant _WaveClipper oldClipper) => false;
}

class _WaveBorder extends CustomPainter {
  const _WaveBorder({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      _wavePath(size),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
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

  final Color tab;
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
        tab: Color(0xFF422F26),
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
      tab: AppColors.homeAir,
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
