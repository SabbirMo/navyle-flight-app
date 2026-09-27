import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navyla_flight_app/feature/ai_chat/model/chat_message_model.dart';

class ChatState {
  final List<ChatMessageModel> messages;
  final bool isGenerating;

  const ChatState({
    required this.messages,
    this.isGenerating = false,
  });

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isGenerating,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}

class ChatNotifier extends Notifier<ChatState> {
  @override
  ChatState build() {
    return ChatState(
      messages: [
        ChatMessageModel(
          id: '1',
          text:
              "Hi Alex! I'm your NAVYLA Assistant. I have your flight details for **BA 0215** to **JFK**.\n\nHow can I help you today?",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ChatMessageModel(
          id: '2',
          text: "What is my next step to boarding",
          isUser: true,
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
        ChatMessageModel(
          id: '3',
          text: "Thinking answer...",
          isUser: false,
          timestamp: DateTime.now().subtract(const Duration(seconds: 30)),
          isThinking: true,
        ),
      ],
      isGenerating: false,
    );
  }

  /// Sends a message from the user and simulates an assistant response
  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final userMsg = ChatMessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: trimmed,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final thinkingMsgId =
        'thinking_${DateTime.now().millisecondsSinceEpoch}';
    final thinkingMsg = ChatMessageModel(
      id: thinkingMsgId,
      text: "Thinking answer...",
      isUser: false,
      timestamp: DateTime.now(),
      isThinking: true,
    );

    // Filter out previous unfinished thinking message if any, then append
    final currentList =
        state.messages.where((m) => !m.isThinking).toList();

    state = state.copyWith(
      messages: [...currentList, userMsg, thinkingMsg],
      isGenerating: true,
    );

    try {
      // Simulate AI generation delay
      await Future.delayed(const Duration(milliseconds: 1400));

      final replyText = _generateSmartReply(trimmed);

      final updatedList = state.messages.map((m) {
        if (m.id == thinkingMsgId) {
          return m.copyWith(
            text: replyText,
            isThinking: false,
          );
        }
        return m;
      }).toList();

      state = state.copyWith(
        messages: updatedList,
        isGenerating: false,
      );
    } catch (_) {
      state = state.copyWith(isGenerating: false);
    }
  }

  String _generateSmartReply(String query) {
    final q = query.toLowerCase();
    if (q.contains('boarding') || q.contains('step') || q.contains('gate')) {
      return "Your boarding for **BA 0215** starts at **11:15 AM** at **Gate B22**.\n\nYou are currently near Security 2. Proceed straight and take the escalator to Concourse B (approx. 5 mins walk).";
    } else if (q.contains('food') || q.contains('eat') || q.contains('shop') || q.contains('coffee')) {
      return "There is a **Starbucks** and **Shake Shack** right across from Gate B20, open until 10:00 PM.";
    } else if (q.contains('wifi') || q.contains('internet')) {
      return "Connect to **JFK_Free_WiFi** and accept the terms to get complimentary high-speed internet.";
    } else if (q.contains('baggage') || q.contains('luggage')) {
      return "Baggage drop is located at **Terminal 7, Row C**. Standard drop closes 45 mins before departure.";
    } else {
      return "I've checked your itinerary for **BA 0215**. Everything is on schedule for departure at **11:55 AM** from **Gate B22**.";
    }
  }
}

final chatNotifierProvider =
    NotifierProvider<ChatNotifier, ChatState>(ChatNotifier.new);
