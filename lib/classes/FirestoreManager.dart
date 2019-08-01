import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'dart:async';
//import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:collection';

/// Each user must get the current location of the other user, how?
/// Have a "usersToShareLocationWith" which gets added during the comparison for incoming/outgoing selfie (updatelocation method)
/// That will store a reference to each user
/// Then we will use the reference to fetch the location of each user along with name and stuff to generate the marker info
/// Have to make a read request for each user though (so 3 users in array would equal 3 read request every 10 seconds)
/// Then generate a marker on the user screen for each of those users at the given geoPoints
/// Update screen & markers every 10 seconds

class FirestoreManager {
  // Public data
  static String username = "testUser1"; // Or phone number
  static String keyDisplayName = "displayName";
  static String keyRarityBorder = 'rarityBorder';
  static String keyPhotos = 'photos';
  static String keyFriendliness = 'friendliness';
  static String keyFame = 'fame';
  static String keyIsCosplayer = 'isCosplayer';
  static String keyIsPhotographer = 'isPhotographer';
  static String keyRealName = 'realName'; // TODO remove real name this isn't required
  static String keyDateRegistered = 'dateRegistered'; // This should be public that's fine
  static String keyCosplayName = 'cosplayName';
  static String keySeriesName = 'seriesName';
  static String keyCosplayerCost = 'cosplayerCost';
  static String keyPhotographerCost = 'photographerCost';
  static String keyPhotographyYearsExperience = 'photographyYearsExperience';
  static String keyPhotographyMonthsExperience = 'photographyMonthsExperience';
  static String keyCosplayYearsExperience = 'cosplayYearsExperience';
  static String keyCosplayMonthsExperience = 'cosplayMonthsExperience';
  static String keyIncomingSelfieRequests = 'incomingSelfieRequests'; // TODO this should be private
  static String keyOutgoingSelfieRequests = 'outgoingSelfieRequests'; // TODO this should be private
  static String keyDocumentReference = 'documentReference';
  static String keyIsSharingLocation = 'isSharingLocation'; // not used? // TODO not used delete>
  static String keyDocumentId = 'documentId';

  // In the database but in a private collection
  static String keyPosition = 'position';

  // These keys are not in databases but calculated locally using the database information
  static String keyIsInSelfieMode = 'isInSelfieMode';
  static String keyUsersToShareLocationWith = 'usersToShareLocationWith';

  static Timer _locationUpdateTimer;

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
    // Going into our user collection and finding a user by their display name
    _getUserByDisplayName("Chibata").snapshots().listen(
      (doc) {
        print("---------------Database Updated----------------------");
        print("Updating local logged in user information");
        FirestoreReadcheck.userProfileReads++;
        FirestoreReadcheck.printUserProfileReads();

        // Go through each document in the user and update the local data
        _copyUserDatabaseInformationToLocalData(doc.documents[0], loggedInUser);

        // Create timer here and pass into updatePosition
        // Whenever this stream emits new data, cancel the timer then create a new one

        _startPositionUpdateTimer(loggedInUser, doc.documents[0]);

        // callback notifies listeners of loggedInUser
        callback();
      },
    ).onError((error) {
      //TODO need to tell user it failed with a widget...
      print("FirestoreManager stream failed");
      return Future.error("$error");
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

  // Takes all documentSnapshots and copies to loggedInUser
  static _copyUserDatabaseInformationToLocalData(DocumentSnapshot documentSnapshot, LoggedInUser loggedInUser) {
    loggedInUser.getHashMap[FirestoreManager.keyDocumentReference] = documentSnapshot.reference;
    loggedInUser.getHashMap[FirestoreManager.keyDocumentId] = documentSnapshot.documentID;
    documentSnapshot.data.forEach((key, value) {
      //print("Updating $key...$value");
      FirestoreManager.keys[key] = key; // (delete) Not useful
      loggedInUser.getHashMap[key] = value;
    });
  }

  static _startPositionUpdateTimer(LoggedInUser loggedInUser, DocumentSnapshot documentSnapshot) async {
    // TODO NEED SEPERATIONS
    if (LoggedInUser.isInSelfieMode(loggedInUser)) {
      loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode] = true;
      if (_locationUpdateTimer == null) {
        print("Location update timer is null so create a timer");
        // Initial position update
        await _sendPositionToDatabase(documentSnapshot);
        print("Why is this not called-----------------------------------------------------------------------");
        _locationUpdateTimer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
          if (loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode] == false) {
            print("!_!+_!+_!+_!+!_ CANCELLING TIMER __+_++_+__+__+!_+!_+_+!__!+_+!_+!_!_");
            t.cancel();
          }
          print("TIMER RAN _--------------------------------------------------_");
          await _sendPositionToDatabase(documentSnapshot);
        });
      } else {
        print("Location update timer already exist DO NOT RECREATE");
      }
      print("IN SELFIE MODE + STARTING TIMER..................................");
    } else {
      loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode] = false;
      if (_locationUpdateTimer != null) {
        print("Cancel update timer due to selfie mode being off (locationUpdateTimer != null)");
        _locationUpdateTimer.cancel();
        _locationUpdateTimer = null;
      }
      print("NOT IN SELFIE MODE");
    }
  }

  static _sendPositionToDatabase(DocumentSnapshot documentSnapshot) async {
    // TODO NOT OPTIMIZED!
    print("Creating position to send to database");
    //final Location location = Location();
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((error) {
      print(error);
      return Future.error(error);
    });
    final Geoflutterfire geo = Geoflutterfire();
//    final pos = await location.getLocation().catchError((error) {
//      print("ERROR IN SENDPOSITIONTODATABASE");
//      return Future.error(error);
//    });
    print("After creating position to send to database");
    double lat = location.latitude;
    double lng = location.longitude;

    GeoFirePoint newGeoPoint = geo.point(latitude: lat, longitude: lng);
    print("newGeoPoint: ${newGeoPoint.longitude} ${newGeoPoint.latitude}");
    // TODO uncomment this for database update location, also need to handle errors here
    //await documentSnapshot.reference.setData({FirestoreManager.keyPosition: newGeoPoint.data}, merge: true);
    // Update users location to the database
    print("Added location to locations database for ${documentSnapshot.documentID}");

    // TODO this should be initially made to point to google headquarters to make sure each users have this enabled on creation
    // TODO change to updata data since each users will already have it by default (updateData)
    Firestore.instance.collection("locations").document(documentSnapshot.documentID).setData({
      FirestoreManager.keyPosition: newGeoPoint.data,
    }, merge: true);
  }

  static Query _getUserByDisplayName(String name) {
    return Firestore.instance.collection("users").where(FirestoreManager.keyDisplayName, isEqualTo: name).limit(1);
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
