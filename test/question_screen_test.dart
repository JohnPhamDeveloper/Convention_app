import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_app/screens/question_screen.dart';

void main() {
  // IconFormField
  testWidgets('Question screen should have a stack with questions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: QuestionScreen(),
        ),
      ),
    );

//    final questionFinder = find.byWidget(widget)
//
//    // Should be two since there's hintText and labelText (The one above hint)
//    expect(hintTextFinder, findsNWidgets(2));
//    expect(iconFinder, findsOneWidget);
  });
}
