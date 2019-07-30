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
  static String keyDateRegistered = 'dateRegistered';
  static String keyCosplayName = 'cosplayName';
  static String keySeriesName = 'seriesName';
  static String keyCosplayerCost = 'cosplayerCost';
  static String keyPhotographerCost = 'photographerCost';
  static String keyPhotographyYearsExperience = 'photographyYearsExperience';
  static String keyPhotographyMonthsExperience = 'photographyMonthsExperience';
  static String keyCosplayYearsExperience = 'cosplayYearsExperience';
  static String keyCosplayMonthsExperience = 'cosplayMonthsExperience';
  static String keyDocumentID = "documentID";

  // (delete) not useful
  static HashMap<String, String> keys = HashMap<String, String>();

  static Future<void> createUserInDatabase({
    String documentName,
    int fame,
    int friendliness,
    String displayName,
    List<String> photoUrls,
    bool isCosplayer,
    bool isPhotographer,
    String cosplayName,
    String seriesName,
    int rarityBorder,
    String realName,
    String cosplayerCost,
    String photographerCost,
    int photographyYearsExperience,
    int photographyMonthsExperience,
    int cosplayYearsExperience,
    int cosplayMonthsExperience,
  }) async {
    await Firestore.instance
        .collection("users")
        .document(documentName)
        .setData({
      keyFame: fame,
      keyFriendliness: friendliness,
      keyDisplayName: displayName,
      keyPhotos: photoUrls,
      keyIsCosplayer: isCosplayer,
      keyIsPhotographer: isPhotographer,
      keyRarityBorder: rarityBorder,
      keyRealName: realName,
      keyCosplayName: cosplayName,
      keySeriesName: seriesName,
      keyCosplayerCost: cosplayerCost,
      keyPhotographerCost: photographerCost,
      keyPhotographyYearsExperience: photographyYearsExperience,
      keyPhotographyMonthsExperience: photographyMonthsExperience,
      keyCosplayYearsExperience: cosplayMonthsExperience,
      keyCosplayYearsExperience: cosplayYearsExperience,
      keyDateRegistered: DateTime.now(),
    }, merge: true);
    print("Finished creating mock user");
  }

  // Updates local user information using the database information whenever
  // the database changes (stream)
  // Callback is called when data is done loading
  static void streamUserData(LoggedInUser loggedInUser, Function callback) {
    Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: "Hakunom")
        .getDocuments()
        .asStream()
        .listen((doc) {
      print("---------------Database Updated----------------------");
      print("Updating local logged in user information");
      // Go through each document in the user and update the local data
      _copyUserDatabaseInformationToLocalData(doc.documents[0], loggedInUser);
      callback();
    });
//
//    try {
//      Firestore.instance
//          .collection("users")
//          .document('testUser3')
//          .snapshots()
//          .listen((doc) {
//        print("---------------Database Updated----------------------");
//        print("Updating local logged in user information");
//        // Go through each document in the user and update the local data
//        _copyUserDatabaseInformationToLocalData(doc, loggedInUser);
//        callback();
//      });
//    } catch (e) {
//      print(e);
//    }
  }

  // Takes all documentSnapshots and copies to loggedInUser
  static _copyUserDatabaseInformationToLocalData(
      DocumentSnapshot documentSnapshot, LoggedInUser loggedInUser) {
    documentSnapshot.data.forEach((key, value) {
      print("Updating $key...");
      FirestoreManager.keys[key] = key; // (delete) Not useful
      loggedInUser.getHashMap[key] = value;
    });
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
