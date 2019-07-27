import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';

class FirestoreManager {
  // Gets information from database and returns that information ina LoggedInUser object
  static Future<LoggedInUser> getUserInformationFromFirestore() async {
    String username = "testUser1"; // Or phone number
    String keyDisplayName = "displayName";
    String keyRarityBorder = 'rarityBorder';
    String keyPhotos = 'photos';
    String keyFriendliness = 'friendliness';
    String keyFame = 'fame';
    List<dynamic> photosURL = List<dynamic>();
    DocumentSnapshot snapshot;

    print("Fetching database...");

    try {
      snapshot =
          await Firestore.instance.collection("users").document(username).get();
    } catch (e) {
      print(e);
    }

    photosURL = snapshot.data[keyPhotos];
    int friendliness = snapshot.data[keyFriendliness];
    int fame = snapshot.data[keyFame];
    String displayName = snapshot.data[keyDisplayName];
    int rarityBorder = snapshot.data[keyRarityBorder];

    print("Done getting user information...");

    return LoggedInUser(
        photosURL, displayName, rarityBorder, friendliness, fame);
  }
}
