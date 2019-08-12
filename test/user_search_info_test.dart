//import 'package:flutter/material.dart';
//import 'package:flutter_test/flutter_test.dart';
//import 'package:cosplay_app/widgets/SearchSection.dart';
//import 'package:cosplay_app/widgets/SearchSectionItem.dart';
//import 'package:cosplay_app/widgets/UserSearchInfo.dart';
//import 'package:mockito/mockito.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:provider/provider.dart';
//import 'package:cosplay_app/classes/LoggedInUser.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'dart:collection';
//
//class FirebaseUserMock extends Mock implements FirebaseUser {}
//
//class LoggedInUserMock extends Mock implements LoggedInUser {}
//
//List<Map<String, dynamic>> nearbyUsers = List<Map<String, dynamic>>();
//final Map<String, dynamic> testUser = {
//  'circleImageUrl': 'https://c.pxhere.com/photos/0b/f9/anime_girl_japan_japanese_tokyo_cosplay-266599.jpg!d',
//  'fame': 210,
//  'displayName': 'Chibata',
//  'seriesName': 'Tales of Abyss',
//  'cosplayName': 'Luke',
//  'friendliness': 788,
//  'rarityBorder': 1,
//  'isCosplayer': true,
//  'isPhotographer': false,
//  'distance': 3.687838025928577,
////  'snapshot': 'Instance of'
//};
//
//void main() {
//  FirebaseUserMock mockUser = FirebaseUserMock();
//  LoggedInUserMock logUser = LoggedInUserMock();
//  nearbyUsers.add(testUser);
//
//  testWidgets('Search section has a search section page view section', (WidgetTester tester) async {
//    LatLng latLng = LatLng(0.0, 0.0);
////    when(logUser.getUsersNearby).thenReturn(nearbyUsers);
////    expect(logUser.getUsersNearby, nearbyUsers);
////
//    when(logUser.getHashMap).thenReturn(nearbyUsers[0]);
//    expect(logUser.getHashMap, nearbyUsers[0]);
//
//    await tester.pumpWidget(
//      MaterialApp(
//        home: Scaffold(
//          body: ChangeNotifierProvider<LoggedInUser>(
//            builder: (context) => logUser,
//            child: Consumer<LoggedInUser>(
//                builder: (context, value, child) => UserSearchInfo(onTap: (){}),
//            ),
//          ),
//        ),
//      ),
//    );
//
//    tester.widget(find.byKey(Key('searchSectionPageView')));
//  });
//}
