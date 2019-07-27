class LoggedInUser {
  final List<dynamic> _photosURL; // The reference to all of the user's photos
  final String _displayName;
  final int _rarityBorder;
  final int _friendliness;
  final int _fame;

  LoggedInUser(this._photosURL, this._displayName, this._rarityBorder,
      this._friendliness, this._fame);

  int get fame => _fame;
  int get friendliness => _friendliness;
  int get rarityBorder => _rarityBorder;
  String get displayName => _displayName;
  List<dynamic> get photosURL => _photosURL;
}
