import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:cosplay_app/classes/Meetup.dart';

class HeroCreator {
  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView(
      String dotHeroName, String imageHeroName, DocumentReference otherUserDataReference, BuildContext context) async {
    // Get latest snapshot of the user from the database
    print("getting latest database information?");

    // Get other user data for profile display
    DocumentSnapshot otherUserDataSnapshot = await otherUserDataReference.get().catchError((error) {
      //TODO need to tell user it failed with a widget...
      print("pushProfileIntoView failed to get otherUserDataSnapshot from otherUserDataReference");
      print("The error is: $error");
      return Future.error("pushProfileIntoView failed to get otherUserDataSnapshot from otherUserDataReference");
    });

    FirestoreReadcheck.heroCreatorReads++;
    FirestoreReadcheck.printHeroCreatorReads();

    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);

    HeroProfileStart heroProfileStart =
        HeroCreator.createHeroProfileStart(dotHeroName, imageHeroName, otherUserDataSnapshot, currentLoggedInUser);

    HeroProfileDetails heroProfileDetails =
        HeroCreator.createHeroProfileDetails(otherUserDataSnapshot, context, currentLoggedInUser);
    Widget clickedProfile = HeroCreator._wrapInScaffold([heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

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
      DocumentSnapshot otherUserDocumentSnapshot, BuildContext context, LoggedInUser currentLoggedInUser) {
    // Build a profile with different buttons if they're looking at themselves
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, otherUserDocumentSnapshot);

    bool displayRequestButton = false;
    bool displayAcceptButton = false;
    bool displayFinishButton = false;

    // Get logged in users incoming and outgoing selfie requests
    List<dynamic> loggedInUserIncomingSelfie = currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];
    List<dynamic> loggedInUserOutgoingSelfie = currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];

    // If current user sent and recieved a selfie request from other user
    if (loggedInUserIncomingSelfie.contains(otherUserDocumentSnapshot.documentID) &&
        loggedInUserOutgoingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user received and sent selfie request from other user");
      displayFinishButton = true;
    }

    // Display accept button if the other person exists in logged in user incoming list
    // If current user received a selfie request from other user
    else if (loggedInUserIncomingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user received selfie request from other user");
      displayAcceptButton = true;
    }
    // If current user didnt recieve or send selfie request to the other user
    else if (loggedInUserOutgoingSelfie.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user didnt send or receive selfie from other user");
      displayRequestButton = true;
    }

    return HeroProfileDetails(
      onSelfieRequestTap: () {
        _onSelfieRequestTap(otherUserDocumentSnapshot);
      },
      onSelfieAcceptTap: () {
        _onSelfieAcceptTap(otherUserDocumentSnapshot);
      },
      onSelfieFinishTap: () {
        _onSelfieFinishTap(otherUserDocumentSnapshot);
      },
      displayAcceptButton: displayAcceptButton,
      displayRequestButton: displayRequestButton,
      displayFinishButton: displayFinishButton,
      isLoggedInUser: isLookingAtOwnProfile,
      userCircleImage: otherUserDocumentSnapshot[FirestoreManager.keyPhotos][0],
      rarityBorder: otherUserDocumentSnapshot[FirestoreManager.keyRarityBorder],
      displayName: otherUserDocumentSnapshot[FirestoreManager.keyDisplayName],
      friendliness: otherUserDocumentSnapshot[FirestoreManager.keyFriendliness],
      fame: otherUserDocumentSnapshot[FirestoreManager.keyFame],
    );
  }

  /// HELPERS ----------------------------------
  ///
  ///
  ///
  ///

  static void _onSelfieRequestTap(DocumentSnapshot otherUserData) async {
    // TODO restrict people within distance, if they are out of distance, record malicious attempt
    final response = await Meetup.sendSelfieRequestTo(otherUserData);
    print(response.data);
  }

  static void _onSelfieAcceptTap(DocumentSnapshot otherUserData) async {
    final response = await Meetup.sendSelfieRequestTo(otherUserData);
    print(response.data);
    final response2 = await Meetup.acceptSelfieFrom(otherUserData);
    print("RESPONSE OF BIG BIG THING <<<<<<<<<<<<<<<<<<<<<<<<<<<<,,");
    print(response2.data);
  }

  static void _onSelfieFinishTap(DocumentSnapshot otherUserData) async {
    final response = await Meetup.finishSelfie(otherUserData);
    print(response.data);
  }

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }

  static _wrapInScaffold(List<Widget> heros, BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: HeroProfilePage(
          pages: heros,
        ),
      ),
    );
  }
}
