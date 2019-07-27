import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'dart:collection';

class FirestoreManager {
  static String username = "testUser1"; // Or phone number
  static String keyDisplayName = "displayName";
  static String keyRarityBorder = 'rarityBorder';
  static String keyPhotos = 'photos';
  static String keyFriendliness = 'friendliness';
  static String keyFame = 'fame';
  static String keyIsCosplayer = 'isCosplayer';
  static String keyIsPhotographer = 'isPhotographer';
  static String keyRealName = 'realName';

  // All of database keys are stored in here (not sure if this is used)
  static HashMap<String, String> keys = HashMap<String, String>();

  // Updates user information to the database information whenever
  // The database changes
  static void streamUserData(LoggedInUser loggedInUser, Function callback) {
    try {
      Firestore.instance
          .collection("users")
          .document('testUser1')
          .snapshots()
          .listen((doc) {
        print("---------------Database Updated----------------------");
        print("Updating local logged in user information");
        doc.data.forEach((key, value) {
          // Iterate through all keys in the database
          // Store key in FirestoreManager fireStoreManagerKeys[key] = [key]
          // Store user[key] = [value];
          // Notify listeners
          // Store keys in here incase we need it locally
          print("Updating $key...");
          FirestoreManager.keys[key] = key;
          loggedInUser.getHashMap[key] = value;
        });
        callback();
      });
    } catch (e) {
      print(e);
    }
  }

  // Gets information from database and returns that information in a LoggedInUser object
//  static Future<LoggedInUser> getUserInformationFromFirestore() async {
//    LoggedInUser _tempLoggedInUser;
//
//    print("Fetching database...");
//
//    try {
//      await Firestore.instance
//          .collection("users")
//          .document(username)
//          .snapshots()
//          .forEach((snapshot) {
//        snapshot.data.forEach((key, value) {
//          _tempLoggedInUser.getHashMap[key] = value;
//        });
//      });
//    } catch (e) {
//      print(e);
//      // TODO Getting user information fails
//      // If fails, we should log out user and kick user out back to login screen
//      // We will retry though and give the user information on screen that we're retrying...
//    }
//
////    List<dynamic> photosURL = snapshot.data[keyPhotos];
////    int friendliness = snapshot.data[keyFriendliness];
////    int fame = snapshot.data[keyFame];
////    String displayName = snapshot.data[keyDisplayName];
////    int rarityBorder = snapshot.data[keyRarityBorder];
//
//    print("Done getting user information...");
//
//    return _tempLoggedInUser;
////    return LoggedInUser(
////        photosURL, displayName, rarityBorder, friendliness, fame);
//  }

//  // Get snapshot of users information in database
//  static Future<DocumentSnapshot> getSnapshot() async {
//    DocumentSnapshot snapshot =
//        await Firestore.instance.collection("users").document(username).get();
//    return snapshot;
//  }

//  // Update user information in database
//  static Future<bool> update(Map<String, dynamic> newData) async {
//    print("Trying to update data");
//    try {
//      await Firestore.instance
//          .collection("users")
//          .document(username)
//          .updateData(newData);
//      return true;
//    } catch (e) {
//      print(e);
//    }
//    return false;
//  }
}
