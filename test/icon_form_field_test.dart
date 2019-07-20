import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_app/widgets/IconFormField.dart';

void main() {
  // IconFormField
  testWidgets(
      'IconFormField has a hintText, invalidText, icon, controller, and textInputType',
      (WidgetTester tester) async {
    final String hintText = "Email";
    final String invalidEmail = "Invalid Email";
    final TextEditingController tec = TextEditingController(text: 'bob');

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IconFormField(
              hintText: hintText,
              invalidText: invalidEmail,
              icon: Icons.email,
              controller: tec,
              textInputType: TextInputType.emailAddress),
        ),
      ),
    );

    final hintTextFinder = find.text(hintText);
    final iconFinder = find.byIcon(Icons.email);

    // Should be two since there's hintText and labelText (The one above hint)
    expect(hintTextFinder, findsNWidgets(2));
    expect(iconFinder, findsOneWidget);
  });
}
