import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

/// Reusable helper for sharing text, links, and invoking system share sheets.
class AppShareHelper {
  const AppShareHelper._();

  static const String defaultShareText =
      "Check out NAVYLA! The ultimate airport and flight companion app. From Home to Gate. Download now: https://navyla.com";
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
    final box = context.findRenderObject() as RenderBox?;
    final origin = (box != null && box.hasSize)
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(text: text, subject: subject, sharePositionOrigin: origin),
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
