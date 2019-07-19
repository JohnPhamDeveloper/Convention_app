import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_app/widgets/IconFormField.dart';

void main() {
  // IconFormField
  testWidgets(
      'IconFormField has a hintText, invalidText, icon, controller, and textInputType',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      IconFormField(
          hintText: "Email",
          invalidText: "Invalid Email",
          icon: Icons.email,
          controller: TextEditingController(),
          textInputType: TextInputType.emailAddress),
    );

    final hintTextFinder = find.text('Email');
    final invalidTextFinder = find.text('Invalid Email');
    final iconFinder = find.



  });
}
