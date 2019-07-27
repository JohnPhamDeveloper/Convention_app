import 'package:flutter/foundation.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
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

  void updateWidgetsListeningToThis() {
    notifyListeners();
  }

  // Not used
//  LoggedInUser.copy(LoggedInUser loggedInUser) {
//    this._photosURL = loggedInUser.photosURL;
//    this._displayName = loggedInUser.displayName;
//    this._rarityBorder = loggedInUser.rarityBorder;
//    this._fame = loggedInUser.fame;
//    this._friendliness = loggedInUser.friendliness;
//    this._isCosplayer = loggedInUser._isCosplayer;
//  }

  // Update database
//  Future<bool> set(SetActions actions, dynamic value) async {
//    bool success = false;
//
//    switch (actions) {
//      case SetActions.SET_FAME:
//        _fame = value;
//        break;
//      case SetActions.SET_FRIENDLINESS:
//        _friendliness = value;
//        break;
//      case SetActions.SET_RARITY_BORDER:
//        _rarityBorder = value;
//        break;
//      case SetActions.SET_DISPLAY_NAME:
//        _displayName = value;
//        break;
//      case SetActions.SET_IS_COSPLAYER:
//        _isCosplayer = value;
//        break;
//      case SetActions.SET_REAL_NAME:
//        _realName = value;
//        break;
//      case SetActions.SET_IS_PHOTOGRAPHER:
//        _isPhotographer = value;
//        break;
//      case SetActions.SET_PHOTOS_URL:
//        _photosURL = value;
//        break;
//    }
//
//    // _refreshInformation(success);
//
//    return success;
//  }

  // Gets fresh data from database and stores it
//  void _refreshInformation(bool success) async {
//    if (!success) return;
//    await FirestoreManager.getSnapshot().then((value) {
//      _rarityBorder = value.data[FirestoreManager.keyRarityBorder];
//      _fame = value.data[FirestoreManager.keyFame];
//      _friendliness = value.data[FirestoreManager.keyFriendliness];
//      _photosURL = value.data[FirestoreManager.keyPhotos];
//      _displayName = value.data[displayName];
//    });
//    notifyListeners();
//  }

  HashMap<String, dynamic> get getHashMap => _hashMap;
//  int get fame => _fame;
//  int get friendliness => _friendliness;
//  int get rarityBorder => _rarityBorder;
//  String get displayName => _displayName;
//  List<dynamic> get photosURL => _photosURL;
}
