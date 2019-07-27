import 'package:flutter/foundation.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

class LoggedInUser extends ChangeNotifier {
  List<dynamic> _photosURL; // The reference to all of the user's photos
  String _displayName;
  int _rarityBorder;
  int _friendliness;
  int _fame;

  LoggedInUser(this._photosURL, this._displayName, this._rarityBorder,
      this._friendliness, this._fame);

  Future<bool> setRarityBorder(int newRarity) async {
    bool success = await FirestoreManager.update({
      FirestoreManager.keyRarityBorder.toString(): newRarity.toString(),
    });

    // Notify
    if (success) {}

    return success;
  }

  Future<bool> setFriendliness(int newValue) async {
    bool success = await FirestoreManager.update(
      {FirestoreManager.keyFriendliness.toString(): newValue.toString()},
    );

    return success;
  }

  Future<bool> setFame(int newValue) async {
    bool success = await FirestoreManager.update(
      {FirestoreManager.keyFame.toString(): newValue.toString()},
    );

    return success;
  }

  int get fame => _fame;
  int get friendliness => _friendliness;
  int get rarityBorder => _rarityBorder;
  String get displayName => _displayName;
  List<dynamic> get photosURL => _photosURL;
}
