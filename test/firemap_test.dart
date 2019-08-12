import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosplay_app/widgets/FireMap.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';

class FirebaseUserMock extends Mock implements FirebaseUser {}

class LoggedInUserMock extends Mock implements LoggedInUser {}

void main() {
  testWidgets('FireMap only renders googlemap', (WidgetTester tester) async {
    FirebaseUserMock mockUser = FirebaseUserMock();
    LoggedInUserMock logUser = LoggedInUserMock();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<LoggedInUser>(
            builder: (context) => logUser,
            child: Consumer<LoggedInUser>(
              builder: (context, value, child) => FireMap(loggedInUserAuth: mockUser),
            ),
          ),
        ),
      ),
    );

    tester.widget(find.byKey(Key('googlemap')));
  });
}
