import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

/// Reusable helper for sharing text, links, and invoking system share sheets.
class AppShareHelper {
  const AppShareHelper._();

  static const String defaultShareText =
      "Check out NAVYLA! The ultimate airport and flight companion app. From Home to Gate. Download now: https://navyla.app";
  static const String defaultSubject = "NAVYLA - Made for Travelers";

  /// Opens the native platform share sheet via [SharePlus].
  ///
  /// Automatically computes [sharePositionOrigin] from [context]
  /// to ensure safe positioning on iPads and large-screen devices.
  static Future<void> shareWithSystem(
    BuildContext context, {
    String text = defaultShareText,
    String subject = defaultSubject,
  }) async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      final origin = (box != null && box.hasSize)
          ? box.localToGlobal(Offset.zero) & box.size
          : null;

      await SharePlus.instance.share(
        ShareParams(text: text, subject: subject, sharePositionOrigin: origin),
      );
    } catch (e) {
      debugPrint('SharePlus error: $e');
    }
  }

  /// Shares boarding pass details via native system share sheet.
  static Future<void> shareBoardingPass(
    BuildContext context, {
    required String flightNumber,
    required String originCode,
    required String destinationCode,
    String? airlineName,
    String? passengerName,
    String? date,
    String? seat,
    String? gate,
    String? terminal,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln(
      '✈️ Boarding Pass: $flightNumber${airlineName != null && airlineName.isNotEmpty ? ' ($airlineName)' : ''}',
    );
    buffer.writeln('📍 $originCode ➔ $destinationCode');
    if (passengerName != null && passengerName.isNotEmpty) {
      buffer.writeln('👤 Passenger: $passengerName');
    }
    if (date != null && date.isNotEmpty) {
      buffer.writeln('📅 Date: $date');
    }
    final details = [
      if (seat != null && seat.isNotEmpty) 'Seat: $seat',
      if (gate != null && gate.isNotEmpty) 'Gate: $gate',
      if (terminal != null && terminal.isNotEmpty) 'Terminal: $terminal',
    ];
    if (details.isNotEmpty) {
      buffer.writeln('🎫 ${details.join(' | ')}');
    }
    buffer.writeln('\nShared via NAVYLA - From Home to Gate: https://navyla.app');

    await shareWithSystem(
      context,
      text: buffer.toString(),
      subject: 'Boarding Pass - $flightNumber ($originCode to $destinationCode)',
    );
  }

  /// Handles sharing for a specific channel.
  /// If [channel] is "More", opens the native system share sheet.
  /// Otherwise displays a feedback toast/snackbar.
  static void onSocialShare(
    BuildContext context,
    String channel, {
    String text = defaultShareText,
    String subject = defaultSubject,
  }) {
    if (channel.toLowerCase() == "more") {
      shareWithSystem(context, text: text, subject: subject);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sharing via $channel..."),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
