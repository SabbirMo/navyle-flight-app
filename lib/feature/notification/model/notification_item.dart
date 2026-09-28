import 'package:flutter/material.dart';

enum NotificationType {
  gateChange,
  postVerified,
  securityWarning,
  securityInfo,
}

class NotificationTextSpan {
  final String text;
  final bool isBold;
  final Color? color;

  const NotificationTextSpan({
    required this.text,
    this.isBold = false,
    this.color,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final List<NotificationTextSpan> messageSpans;
  final String timeAgo;
  final String section;
  final NotificationType type;
  final bool isUnread;
  final bool isHighlighted;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.messageSpans,
    required this.timeAgo,
    required this.section,
    required this.type,
    this.isUnread = false,
    this.isHighlighted = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    List<NotificationTextSpan>? messageSpans,
    String? timeAgo,
    String? section,
    NotificationType? type,
    bool? isUnread,
    bool? isHighlighted,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      messageSpans: messageSpans ?? this.messageSpans,
      timeAgo: timeAgo ?? this.timeAgo,
      section: section ?? this.section,
      type: type ?? this.type,
      isUnread: isUnread ?? this.isUnread,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}
