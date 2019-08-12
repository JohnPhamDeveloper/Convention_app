import 'package:test_api/test_api.dart';
import 'package:cosplay_app/verification/verification.dart';

void main() {
  test('validateEmail should return null for a valid email', () {
    String goodEmail = "bob@hotmail.com";
    String invalidMessage = validateEmail(goodEmail);
    expect(invalidMessage, null);
  });

  test('validateEmail should return a string error message for an invalid email', () {
    String badEmail = "bob@hotmail.";
    String badEmail2 = "bob@";
    String badEmail3 = "bob@";
    String invalidMessage = validateEmail(badEmail);
    String invalidMessage2 = validateEmail(badEmail2);
    String invalidMessage3 = validateEmail(badEmail3);
    expect(invalidMessage, 'Enter a valid email');
    expect(invalidMessage2, 'Enter a valid email');
    expect(invalidMessage3, 'Enter a valid email');
  });

  String goodPassword = '123456';
  String badPassword = '';
  String badPassword2 = '12345';

  test('validatePassword should pass', () {
    String invalidMessage = validatePassword(goodPassword);
    expect(invalidMessage, null);
  });

  test('validatePassword should ask for password if empty', () {
    String invalidMessage = validatePassword(badPassword);
    expect(invalidMessage, "Please enter your password");
  });

  test("validatePassword should ask for more than 5 characters for password", () {
    String invalidMessage = validatePassword(badPassword2);
    expect(invalidMessage, "Password must be greater than 5 characters");
  });
}
