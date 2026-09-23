import 'package:flutter_test/flutter_test.dart';
import 'package:navyla_flight_app/core/utils/password_strength.dart';

void main() {
  group('PasswordStrength calculate tests', () {
    test('Empty password returns none', () {
      expect(PasswordStrength.calculate(''), PasswordStrength.none);
    });

    test('Short passwords (< 6 chars) return weak', () {
      expect(PasswordStrength.calculate('123'), PasswordStrength.weak);
      expect(PasswordStrength.calculate('abc'), PasswordStrength.weak);
      expect(PasswordStrength.calculate('Ab1!'), PasswordStrength.weak);
    });

    test('Single character category returns weak', () {
      expect(PasswordStrength.calculate('123456'), PasswordStrength.weak);
      expect(PasswordStrength.calculate('abcdef'), PasswordStrength.weak);
    });

    test('Medium strength passwords', () {
      expect(PasswordStrength.calculate('abc123'), PasswordStrength.medium);
      expect(PasswordStrength.calculate('Passwd'), PasswordStrength.medium);
    });

    test('Good strength passwords', () {
      expect(PasswordStrength.calculate('Password1'), PasswordStrength.good);
      expect(PasswordStrength.calculate('Pass1234'), PasswordStrength.good);
    });

    test('Strong passwords', () {
      expect(PasswordStrength.calculate('Password1@'), PasswordStrength.strong);
      expect(PasswordStrength.calculate('Abcdef123456!'), PasswordStrength.strong);
      expect(PasswordStrength.calculate('MySuperSecretPassword123'), PasswordStrength.strong);
    });
  });
}
