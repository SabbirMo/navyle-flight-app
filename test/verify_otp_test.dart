import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/feature/auth/verify_otp/provider/verify_otp_notifer.dart';

void main() {
  test(
    'VerifyOtpNotifier resets timer to 60s when screen is unmounted and reopened (autoDispose)',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 1. First entry into VerifyOtpScreen (subscribing to provider)
      var sub = container.listen(verifyOtpNotifierProvider, (previous, next) {});
      expect(container.read(verifyOtpNotifierProvider).remainingSeconds, 60);

      // 2. User presses Back button: screen is popped, subscription is closed
      sub.close();

      // Pump microtasks to let Riverpod autoDispose collect unlistened providers
      await Future.delayed(Duration.zero);

      // 3. User taps "Create Account" again: re-enters VerifyOtpScreen
      sub = container.listen(verifyOtpNotifierProvider, (previous, next) {});

      // Timer must restart fresh from 60 seconds!
      expect(container.read(verifyOtpNotifierProvider).remainingSeconds, 60);
      expect(container.read(verifyOtpNotifierProvider).otp, '');
      expect(container.read(verifyOtpNotifierProvider).isResendActive, false);

      sub.close();
    },
  );

  test('VerifyOtpNotifier wrong OTP triggers pinController error and message', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(verifyOtpNotifierProvider, (previous, next) {});
    final notifier = container.read(verifyOtpNotifierProvider.notifier);

    notifier.onPinChanged('9999');
    expect(container.read(verifyOtpNotifierProvider).otp, '9999');

    String? capturedError;
    await notifier.verifyCode(
      onSuccess: () {},
      onError: (msg) {
        capturedError = msg;
      },
    );

    // PinController error state should be triggered
    expect(notifier.pinController.hasError, true);
    expect(container.read(verifyOtpNotifierProvider).errorMessage, isNotNull);
    expect(capturedError, isNotNull);

    // Typing a new digit should auto-clear error
    notifier.onPinChanged('1');
    expect(notifier.pinController.hasError, false);
    expect(container.read(verifyOtpNotifierProvider).errorMessage, isNull);

    sub.close();
  });

  test('VerifyOtpNotifier correct OTP (1234) succeeds', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(verifyOtpNotifierProvider, (previous, next) {});
    final notifier = container.read(verifyOtpNotifierProvider.notifier);

    notifier.onPinChanged('1234');

    bool succeeded = false;
    await notifier.verifyCode(
      onSuccess: () {
        succeeded = true;
      },
    );

    expect(succeeded, true);
    expect(notifier.pinController.hasError, false);
    expect(container.read(verifyOtpNotifierProvider).errorMessage, isNull);

    sub.close();
  });
}
