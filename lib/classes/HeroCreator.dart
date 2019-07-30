import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';

// Used for creating the hero widgets to show the selected user's profile
// into view
class HeroCreator {
  // Creates the two pages
  // Start is the first page and Details is the second page
  static HeroProfileStart createHeroProfileStart(
      String dotHeroName, String imageHeroName, DocumentSnapshot data, LoggedInUser currentLoggedInUser) {
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, data);

    return HeroProfileStart(
      isLoggedInUser: isLookingAtOwnProfile,
      heroName: dotHeroName,
      imageHeroName: imageHeroName,
      userImages: data[FirestoreManager.keyPhotos],
      name: data[FirestoreManager.keyDisplayName],
      friendliness: data[FirestoreManager.keyFriendliness],
      fame: data[FirestoreManager.keyFame],
      bottomLeftItemPadding: EdgeInsets.only(left: 20, bottom: 25),
    );
  }

  static HeroProfileDetails createHeroProfileDetails(
      DocumentSnapshot data, BuildContext context, LoggedInUser currentLoggedInUser) {
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, data);

    return HeroProfileDetails(
      onSelfieRequestTap: () {
        _onSelfieTap(currentLoggedInUser, data);
      },
      isLoggedInUser: isLookingAtOwnProfile,
      userCircleImage: data[FirestoreManager.keyPhotos][0],
      rarityBorder: data[FirestoreManager.keyRarityBorder],
      displayName: data[FirestoreManager.keyDisplayName],
      friendliness: data[FirestoreManager.keyFriendliness],
      fame: data[FirestoreManager.keyFame],
    );
  }

  // Wrap in scaffold since it's a new page
  static wrapInScaffold(List<Widget> heros, BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: HeroProfilePage(
          pages: heros,
        ),
      ),
    );
  }

  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView(String dotHeroName, String imageHeroName, DocumentSnapshot data, BuildContext context) {
    // bool isLoggedInUser = false;

    // Check if the current logged in user is the profile they're trying
    // to bring up (themselves)
    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);

    HeroProfileStart heroProfileStart = HeroCreator.createHeroProfileStart(dotHeroName, imageHeroName, data, currentLoggedInUser);

    HeroProfileDetails heroProfileDetails = HeroCreator.createHeroProfileDetails(data, context, currentLoggedInUser);
    Widget clickedProfile = HeroCreator.wrapInScaffold([heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView2(HeroProfileStart start, HeroProfileDetails details, BuildContext context) {
    Widget clickedProfile = HeroCreator.wrapInScaffold([start, details], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  static void _onSelfieTap(LoggedInUser loggedInUser, DocumentSnapshot otherUserData) async {
    DocumentReference loggedInUserRef;

    print("OnSelfieTap");

    // Get the DocumentReference to the loggedInuser
    await Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: loggedInUser.getHashMap[FirestoreManager.keyDisplayName])
        .getDocuments()
        .then((snapshot) {
      loggedInUserRef = snapshot.documents[0].reference;
      print("Got reference to loggedInUser... $loggedInUserRef");
    });

    // Add the DocumentReference to the selfieRequests list for otherUser
    await Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: otherUserData[FirestoreManager.keyDisplayName])
        .getDocuments()
        .then((snapshot) {
      snapshot.documents[0].reference.setData({
        'selfieRequests': [loggedInUserRef],
      }, merge: true);
    });

//    Firestore.instance
//        .collection('users')
//        .document(otherUserData['documentID'])
//        .setData({
//      'selfieRequests': [loggedInUserRef, loggedInUserRef]
//    }, merge: true);
  }

//  static DocumentReference _getDocumentReferenceByDocumentID(
//      String documentID) {
//    return Firestore.instance.collection('users').document(documentID);
//  }

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }
}
