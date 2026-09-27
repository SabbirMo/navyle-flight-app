import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/ai_chat/provider/chat_notifier.dart';
import 'package:navyla_flight_app/feature/ai_chat/screen/ai_chat_screen.dart';

void main() {
  testWidgets('AIChatScreen renders app bar, messages, and input bar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, child) {
            return const MaterialApp(
              home: AIChatScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify App Bar Title
    expect(find.text('ASK NAVYLA'), findsOneWidget);

    // Verify Timestamp
    expect(find.text('TODAY, 10:45 AM'), findsOneWidget);

    // Verify Messages rendered
    expect(find.text('What is my next step to boarding'), findsOneWidget);
    expect(find.text('Thinking answer...'), findsOneWidget);

    // Verify Input Bar Hint
    expect(find.text('Ask anything...'), findsOneWidget);
  });

  test('ChatNotifier sends message and updates state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initialMessages =
        container.read(chatNotifierProvider).messages;
    expect(initialMessages.length, 3);

    // Send a message
    final sendFuture = container
        .read(chatNotifierProvider.notifier)
        .sendMessage('Where is the food court?');

    // Immediately check that user message & thinking message are added
    final updatedMessages =
        container.read(chatNotifierProvider).messages;
    expect(updatedMessages.any((m) => m.text == 'Where is the food court?'),
        isTrue);

    await sendFuture;

    // After delay, thinking message is resolved into answer
    final finalMessages =
        container.read(chatNotifierProvider).messages;
    expect(finalMessages.any((m) => m.isThinking), isFalse);
    expect(
      finalMessages.last.text.contains('Starbucks') ||
          finalMessages.last.text.contains('Shake Shack'),
      isTrue,
    );
  });

  testWidgets(
      'AIChatScreen sends message on send button tap and displays in UI', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          builder: (context, child) {
            return const MaterialApp(
              home: AIChatScreen(),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Type "hii" into the input field
    final textField = find.byType(TextField);
    expect(textField, findsOneWidget);
    await tester.enterText(textField, 'hii');
    await tester.pump();

    // Tap the send button
    final sendButton = find.byIcon(Icons.send_rounded);
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    await tester.pump();

    // Verify "hii" is now rendered in the chat message list
    expect(find.text('hii'), findsOneWidget);

    // Verify the input field has been cleared
    final TextField inputWidget = tester.widget(textField);
    expect(inputWidget.controller?.text, isEmpty);

    // Fast-forward past AI response delay (1400ms)
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump();

    // Verify assistant smart reply is displayed in RichText
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('BA 0215'),
      ),
      findsAtLeast(1),
    );
  });
}
