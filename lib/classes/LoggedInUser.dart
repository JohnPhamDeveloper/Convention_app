import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoggedInUser extends ChangeNotifier {
  // Database information
  Map<String, dynamic> _hashMap = Map<String, dynamic>();
  LatLng _position;
  List<Map<dynamic, dynamic>> _usersNearby = List<Map<dynamic, dynamic>>();
  FirebaseUser _firebaseUser;

  LoggedInUser();

  updateListeners() {
    notifyListeners();
    //   print("CALLED NOTIFIED LISTENER");
  }

  setPosition(LatLng pos) {
    _position = pos;
  }

  setUsersNearby(List<Map<dynamic, dynamic>> newUsersNearby) {
    _usersNearby = newUsersNearby;
  }

  setFirebaseUser(FirebaseUser user) {
    _firebaseUser = user;
  }

  Map<String, dynamic> get getHashMap => _hashMap;
  List<Map<dynamic, dynamic>> get getUsersNearby => _usersNearby;
  LatLng get getPosition => _position;
  FirebaseUser get getFirebaseUser => _firebaseUser;
}
