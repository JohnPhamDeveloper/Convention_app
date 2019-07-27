import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';

class FirestoreManager {
  static String username = "testUser1"; // Or phone number
  static String keyDisplayName = "displayName";
  static String keyRarityBorder = 'rarityBorder';
  static String keyPhotos = 'photos';
  static String keyFriendliness = 'friendliness';
  static String keyFame = 'fame';

  // Gets information from database and returns that information in a LoggedInUser object
  static Future<LoggedInUser> getUserInformationFromFirestore() async {
    DocumentSnapshot snapshot;

    print("Fetching database...");

    try {
      snapshot =
          await Firestore.instance.collection("users").document(username).get();
    } catch (e) {
      print(e);
      // TODO Getting user information fails
      // If fails, we should log out user and kick user out back to login screen
      // We will retry though and give the user information on screen that we're retrying...
    }

    List<dynamic> photosURL = snapshot.data[keyPhotos];
    int friendliness = snapshot.data[keyFriendliness];
    int fame = snapshot.data[keyFame];
    String displayName = snapshot.data[keyDisplayName];
    int rarityBorder = snapshot.data[keyRarityBorder];

    print("Done getting user information...");

    return LoggedInUser(
        photosURL, displayName, rarityBorder, friendliness, fame);
  }

  // Get snapshot of users information in database
  static Future<DocumentSnapshot> getSnapshot() async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection("users").document(username).get();
    return snapshot;
  }

  // Update user information in database
  static Future<bool> update(Map<String, dynamic> newData) async {
    print("Trying to update data");
    try {
      await Firestore.instance
          .collection("users")
          .document(username)
          .updateData(newData);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
