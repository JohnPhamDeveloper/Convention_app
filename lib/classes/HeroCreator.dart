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
      DocumentSnapshot otherUserDocumentSnapshot, BuildContext context, LoggedInUser currentLoggedInUser) {
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, otherUserDocumentSnapshot);
    bool isOtherUserInIncomingSelfieRequestList = false;
    bool isOtherUserInOutgoingSelfieRequestList = false;

    // Go into our list of references in selfieRequests and check
    // if that profile we're trying to push into view is in out selfieRequest list
    // then a new button will replace the "Selfie request" with "Accept selfie"
    // Also need to construct a "onSelfieAcceptTap"
    List<dynamic> loggedInUserIncomingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];

    List<dynamic> loggedInUserOutgoingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];

    loggedInUserIncomingSelfieReferences.forEach((reference) {
      if (reference == otherUserDocumentSnapshot.reference) {
        isOtherUserInIncomingSelfieRequestList = true;
        return;
      }
    });

    loggedInUserOutgoingSelfieReferences.forEach((reference) {
      if (reference == otherUserDocumentSnapshot.reference) {
        isOtherUserInOutgoingSelfieRequestList = true;
        return;
      }
    });

    return HeroProfileDetails(
      onSelfieIncomingRequestTap: () {
        _onSelfieRequestTap(currentLoggedInUser, otherUserDocumentSnapshot);
      },
      onSelfieIncomingAcceptTap: () {},
      isInSelfieIncomingRequestList: isOtherUserInIncomingSelfieRequestList,
      isInSelfieOutgoingRequestList: isOtherUserInOutgoingSelfieRequestList,
      isLoggedInUser: isLookingAtOwnProfile,
      userCircleImage: otherUserDocumentSnapshot[FirestoreManager.keyPhotos][0],
      rarityBorder: otherUserDocumentSnapshot[FirestoreManager.keyRarityBorder],
      displayName: otherUserDocumentSnapshot[FirestoreManager.keyDisplayName],
      friendliness: otherUserDocumentSnapshot[FirestoreManager.keyFriendliness],
      fame: otherUserDocumentSnapshot[FirestoreManager.keyFame],
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

  // Request selfie from that user
  static void _onSelfieRequestTap(LoggedInUser loggedInUser, DocumentSnapshot otherUserData) async {
    DocumentReference loggedInUserRef;
    DocumentReference otherUserRef;

    // Get the DocumentReference to the loggedInUser (person sending the selfie request)
    await Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: loggedInUser.getHashMap[FirestoreManager.keyDisplayName])
        .getDocuments()
        .then((snapshot) {
      loggedInUserRef = snapshot.documents[0].reference;
    });

    // Add the DocumentReference to the selfieRequests list for otherUser (person receiving selfie request)
    await Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: otherUserData[FirestoreManager.keyDisplayName])
        .getDocuments()
        .then((snapshot) {
      otherUserRef = snapshot.documents[0].reference;
      otherUserRef.setData({
        FirestoreManager.keyIncomingSelfieRequests: [loggedInUserRef],
      }, merge: true);
    });

    // Add the otherUser to the loggedInUser outgoing selfie requests
    await loggedInUserRef.setData({
      FirestoreManager.keyOutgoingSelfieRequests: [otherUserRef],
    }, merge: true);
  }

  static void _onSelfieAcceptTap() {}

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }
}
