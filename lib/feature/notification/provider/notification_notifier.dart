import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/notification/model/notification_item.dart';

class NotificationNotifier extends Notifier<List<NotificationItem>> {
  @override
  List<NotificationItem> build() {
    return [
      const NotificationItem(
        id: '1',
        title: 'GATE',
        messageSpans: [
          NotificationTextSpan(
            text: 'Flight BA245 to New York has changed from Gate A12 to Gate C42.',
          ),
        ],
        timeAgo: '2 MINS AGO',
        section: 'TODAY',
        type: NotificationType.gateChange,
        isUnread: true,
        isHighlighted: true,
      ),
      const NotificationItem(
        id: '2',
        title: 'Post Verified',
        messageSpans: [
          NotificationTextSpan(text: 'Sarah Jenkins ', isBold: true),
          NotificationTextSpan(
            text: 'and 12 others confirmed your update about the B12 Lounge.',
          ),
        ],
        timeAgo: '15 MINS AGO',
        section: 'TODAY',
        type: NotificationType.postVerified,
        isUnread: true,
        isHighlighted: false,
      ),
      const NotificationItem(
        id: '3',
        title: 'Security',
        messageSpans: [
          NotificationTextSpan(text: 'The post of yours is reported as '),
          NotificationTextSpan(text: 'Spam', color: Color(0xFFEF4444)),
          NotificationTextSpan(text: ' by other travelers'),
        ],
        timeAgo: '1 HOUR AGO',
        section: 'TODAY',
        type: NotificationType.securityWarning,
        isUnread: false,
        isHighlighted: false,
      ),
      const NotificationItem(
        id: '4',
        title: 'Security',
        messageSpans: [
          NotificationTextSpan(
            text:
                'Terminal 5 North security is now clearing in under 5 minutes.\nPerfect time to head through!',
          ),
        ],
        timeAgo: 'YESTERDAY, 4:20 PM',
        section: 'YESTERDAY',
        type: NotificationType.securityInfo,
        isUnread: false,
        isHighlighted: false,
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isUnread: false, isHighlighted: false)
        else
          item,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final item in state)
        item.copyWith(isUnread: false, isHighlighted: false),
    ];
  }

  void removeNotification(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void clearAll() {
    state = [];
  }
}

final notificationNotifierProvider =
    NotifierProvider<NotificationNotifier, List<NotificationItem>>(
      NotificationNotifier.new,
    );
