import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    buffer.writeln(
      '\nShared via NAVYLA - From Home to Gate: https://navyla.app',
    );

    await shareWithSystem(
      context,
      text: buffer.toString(),
      subject:
          'Boarding Pass - $flightNumber ($originCode to $destinationCode)',
    );
  }

  /// Handles sharing for a specific channel.
  /// Launches WhatsApp, Messages (SMS), or Email directly via [url_launcher].
  /// If the target app cannot be launched directly (e.g., app not installed or running on simulator),
  /// or if [channel] is "More", it seamlessly opens the native system share sheet.
  static Future<void> onSocialShare(
    BuildContext context,
    String channel, {
    String text = defaultShareText,
    String subject = defaultSubject,
  }) async {
    final lower = channel.toLowerCase().trim();

    if (lower == "more") {
      await shareWithSystem(context, text: text, subject: subject);
      return;
    }

    if (lower == "whatsapp") {
      final appUri = Uri.parse(
        "whatsapp://send?text=${Uri.encodeComponent(text)}",
      );
      final webUri = Uri.parse(
        "https://wa.me/?text=${Uri.encodeComponent(text)}",
      );
      try {
        if (await canLaunchUrl(appUri)) {
          final launched = await launchUrl(
            appUri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) return;
        }
      } catch (e) {
        debugPrint('WhatsApp app launch error: $e');
      }

      try {
        if (await canLaunchUrl(webUri)) {
          final launched = await launchUrl(
            webUri,
            mode: LaunchMode.externalApplication,
          );
          if (launched) return;
        }
      } catch (e) {
        debugPrint('WhatsApp web launch error: $e');
      }

      if (context.mounted) {
        await shareWithSystem(context, text: text, subject: subject);
      }
      return;
    }

    if (lower == "messages" || lower == "sms") {
      final smsUri = Uri(
        scheme: 'sms',
        queryParameters: <String, String>{'body': text},
      );
      try {
        final launched = await launchUrl(
          smsUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      } catch (e) {
        debugPrint('Messages SMS launch error: $e');
      }
      if (context.mounted) {
        await shareWithSystem(context, text: text, subject: subject);
      }
      return;
    }

    if (lower == "email" || lower == "mail") {
      final mailUri = Uri(
        scheme: 'mailto',
        queryParameters: <String, String>{'subject': subject, 'body': text},
      );
      try {
        final launched = await launchUrl(
          mailUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      } catch (e) {
        debugPrint('Email launch error: $e');
      }
      if (context.mounted) {
        await shareWithSystem(context, text: text, subject: subject);
      }
      return;
    }

    // Default fallback
    if (context.mounted) {
      await shareWithSystem(context, text: text, subject: subject);
    }
  }
}
