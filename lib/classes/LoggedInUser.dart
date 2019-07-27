import 'package:flutter/foundation.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

enum Actions {
  SET_RARITY_BORDER,
  SET_FRIENDLINESS,
  SET_FAME,
}

class LoggedInUser extends ChangeNotifier {
  List<dynamic> _photosURL; // The reference to all of the user's photos
  String _displayName;
  int _rarityBorder;
  int _friendliness;
  int _fame;

  LoggedInUser(this._photosURL, this._displayName, this._rarityBorder,
      this._friendliness, this._fame);

  LoggedInUser.copy(LoggedInUser loggedInUser) {
    this._photosURL = loggedInUser.photosURL;
    this._displayName = loggedInUser.displayName;
    this._rarityBorder = loggedInUser.rarityBorder;
    this._fame = loggedInUser.fame;
    this._friendliness = loggedInUser.friendliness;
  }

  // Update database
  Future<bool> set(Actions actions, dynamic value) async {
    bool success = false;

    switch (actions) {
      case Actions.SET_FAME:
        success = await FirestoreManager.update(
          {FirestoreManager.keyFame.toString(): value.toString()},
        );
        break;
      case Actions.SET_FRIENDLINESS:
        success = await FirestoreManager.update(
          {FirestoreManager.keyFriendliness.toString(): value.toString()},
        );
        break;
      case Actions.SET_RARITY_BORDER:
        success = await FirestoreManager.update({
          FirestoreManager.keyRarityBorder.toString(): value.toString(),
        });
        break;
    }

    _refreshInformation(success);

    return success;
  }

  // Gets fresh data from database and stores it
  void _refreshInformation(bool success) async {
    if (!success) return;
    await FirestoreManager.getSnapshot().then((value) {
      _rarityBorder = value.data[FirestoreManager.keyRarityBorder];
      _fame = value.data[FirestoreManager.keyFame];
      _friendliness = value.data[FirestoreManager.keyFriendliness];
      _photosURL = value.data[FirestoreManager.keyPhotos];
      _displayName = value.data[displayName];
    });
    notifyListeners();
  }

  int get fame => _fame;
  int get friendliness => _friendliness;
  int get rarityBorder => _rarityBorder;
  String get displayName => _displayName;
  List<dynamic> get photosURL => _photosURL;
}
