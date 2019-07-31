import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
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
  static String keyIncomingSelfieRequests = 'incomingSelfieRequests';
  static String keyOutgoingSelfieRequests = 'outgoingSelfieRequests';
  static String keyDocumentReference = 'documentReference';
  static String keyIsSharingLocation = 'isSharingLocation';

  static String keyIsInSelfieMode = 'isInSelfieMode'; // note this is not being used in database and only being use locally

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
    await Firestore.instance.collection("users").document(documentName).setData({
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
  static streamUserData(LoggedInUser loggedInUser, Function callback) {
    Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: "Hakunom")
        .limit(1)
        .snapshots()
        .listen((doc) {
      print("---------------Database Updated----------------------");
      print("Updating local logged in user information");
      FirestoreReadcheck.userProfileReads++;
      FirestoreReadcheck.printUserProfileReads();

      // Go through each document in the user and update the local data
      _copyUserDatabaseInformationToLocalData(doc.documents[0], loggedInUser);

      // after we copy all data to local data, check both our incoming and outoing arrays
      // to see if there are similar users in our list.
      // copy incoming array to hashmap
      // iterate through outgoing and check if it exist in the incoming hashmap.
      // if it exists then selfie mode is on; return
      // if it doens't, keep going until we reach the end, then we'll set selfie mode to off

      // callback notifies listener
      callback();
    });
    // Create timer which runs every 10 seconds
    // When should timer stop? When sharing location is off
    // When do we turn it off? When the user is not in selfie mode (or other modes)
    // How do we turn it off? push new database information to turn sharing location off
    // Where do we turn it off in code? When a user clicks finish selfie (other edg cases too like "hangout" or "busines")

//    Timer timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
////      if (doc.documents[0].data[FirestoreManager.keyIsInSelfieMode] == false) {
////        t.cancel();
////      }
////
////      print("Shouldnt be ran + 1");
////      print("Shouldnt be ran + 2");
////      print("Shouldnt be ran + 3");
////      print("Shouldnt be ran + 4");
////      print("Shouldnt be ran + 5");
//
//      // Every 10 seconds should create information for pushing to firestore
//      // Push to firestore
//
//      Location location = Location();
//      Geoflutterfire geo = Geoflutterfire();
//      var pos = await location.getLocation();
//      double lat = pos.latitude;
//      double lng = pos.longitude;
//
//      GeoFirePoint point = geo.point(latitude: lat, longitude: lng);
//
//      // Update position
//      // doc.documents[0].reference.setData({'position': point.data}, merge: true);
//    });

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

  static bool _isInSelfieMode(LoggedInUser loggedInUser) {
    final List<dynamic> outgoingSelfieList = loggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];
    HashMap<DocumentReference, int> incomingSelfieMap = HashMap<DocumentReference, int>();

    // Copy outgoing list to hashmap
    for (int i = 0; i < outgoingSelfieList.length; i++) {
      incomingSelfieMap[outgoingSelfieList[i]] = i;
    }

    // Check if there exists a user thats in outgoing and in incoming
    for (DocumentReference ref in outgoingSelfieList) {
      if (incomingSelfieMap.containsKey(ref)) {
        // If there exist such a user, then we're still in selfie mode
        return true;
      }
    }

    // Not in selfie mode
    return false;
  }

  static _startQueryOnSelfieMode() {}
//

  // Takes all documentSnapshots and copies to loggedInUser
  static _copyUserDatabaseInformationToLocalData(DocumentSnapshot documentSnapshot, LoggedInUser loggedInUser) {
    // NOT NEEDED!?
    // NOT NEEDED!?
    loggedInUser.getHashMap[FirestoreManager.keyDocumentReference] = documentSnapshot.reference;
    //print("PRE: ${loggedInUser.getHashMap[FirestoreManager.keyDocumentReference]}");
    documentSnapshot.data.forEach((key, value) {
      //print("Updating $key...$value");
      FirestoreManager.keys[key] = key; // (delete) Not useful
      loggedInUser.getHashMap[key] = value;
    });

    print('checking....');
    if (_isInSelfieMode(loggedInUser)) {
      loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode] = true;
      print("IN SELFIE MODE");
    } else {
      loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode] = false;
      print("NOT IN SEFIE MODE");
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
