import 'package:flutter/foundation.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:collection';

//enum SetActions {
//  SET_PHOTOS_URL,
//  SET_RARITY_BORDER,
//  SET_FRIENDLINESS,
//  SET_FAME,
//  SET_DISPLAY_NAME,
//  SET_IS_COSPLAYER,
//  SET_IS_PHOTOGRAPHER,
//  SET_REAL_NAME,
//}

class LoggedInUser extends ChangeNotifier {
//  List<dynamic> _photosURL; // The reference to all of the user's photos
//  String _displayName;
//  int _rarityBorder;
//  int _friendliness;
//  int _fame;
//  bool _isCosplayer;
//  bool _isPhotographer;
//  String _realName;
  HashMap<String, dynamic> _hashMap = HashMap<String, dynamic>();

  LoggedInUser();
//
//  printKeys() {
//    print("IS THERE SOMETHING HEE");
//    _hashMap.forEach((string, key) {
//      print("TTTTTTTTTTTTTTT");
//      print(string);
//      print(key);
//    });
//  }

  updateWidgetsListeningToThis() {
    notifyListeners();
    print("CALLED NOTIFIED LISTENER");
  }

  HashMap<String, dynamic> get getHashMap => _hashMap;
}
