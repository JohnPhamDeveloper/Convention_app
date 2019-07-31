import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';

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
    // Build a profile with different buttons if they're looking at themselves
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, otherUserDocumentSnapshot);

    bool isOtherUserInCurrentUserIncomingSelfieRequestList = false;
    bool isOtherUserInCurrentUserOutgoingSelfieRequestList = false;

    List<dynamic> loggedInUserIncomingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];

    List<dynamic> loggedInUserOutgoingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];

    // Check if other use sent a selfie request
    loggedInUserIncomingSelfieReferences.forEach((reference) {
      if (reference == otherUserDocumentSnapshot.reference) {
        isOtherUserInCurrentUserIncomingSelfieRequestList = true;
        print("Other user sent a selfie request to current user");
      }
    });

    // Check if loggedInuser sent a selfie request to other user
    loggedInUserOutgoingSelfieReferences.forEach((reference) {
      print('${reference.toString()} ...');
      if (reference == otherUserDocumentSnapshot.reference) {
        isOtherUserInCurrentUserOutgoingSelfieRequestList = true;
        print("Other user recieved a selfie request from current user");
      }
    });

    return HeroProfileDetails(
      onSelfieIncomingRequestTap: () {
        _onSelfieRequestTap(currentLoggedInUser, otherUserDocumentSnapshot);
      },
      onSelfieIncomingAcceptTap: () {
        _onSelfieAcceptTap(currentLoggedInUser, otherUserDocumentSnapshot);
      },
      isInLoggedInUserSelfieIncomingRequestList: isOtherUserInCurrentUserIncomingSelfieRequestList,
      isInLoggedInUserSelfieOutgoingRequestList: isOtherUserInCurrentUserOutgoingSelfieRequestList,
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
  static pushProfileIntoView(
      String dotHeroName, String imageHeroName, DocumentReference otherUserDataReference, BuildContext context) async {
    // Get latest snapshot of the user from the database
    print("getting latest database information?");
    DocumentSnapshot otherUserDataSnapshot = await otherUserDataReference.get();
    print(otherUserDataSnapshot.data[FirestoreManager.keyIncomingSelfieRequests]);
    FirestoreReadcheck.heroCreatorReads++;
    FirestoreReadcheck.printHeroCreatorReads();

    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);

    HeroProfileStart heroProfileStart =
        HeroCreator.createHeroProfileStart(dotHeroName, imageHeroName, otherUserDataSnapshot, currentLoggedInUser);

    HeroProfileDetails heroProfileDetails =
        HeroCreator.createHeroProfileDetails(otherUserDataSnapshot, context, currentLoggedInUser);
    Widget clickedProfile = HeroCreator.wrapInScaffold([heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  // Construct HeroProfile widget from the information on the clicked avatar
//  static pushProfileIntoView2(HeroProfileStart start, HeroProfileDetails details, BuildContext context) {
//    Widget clickedProfile = HeroCreator.wrapInScaffold([start, details], context);
//
//    // Push that profile into view
//    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
//  }

  // Request selfie from that user
  static void _onSelfieRequestTap(LoggedInUser loggedInUser, DocumentSnapshot otherUserData) async {
    DocumentReference loggedInUserRef = loggedInUser.getHashMap[FirestoreManager.keyDocumentReference];
    DocumentReference otherUserRef;
    await _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(loggedInUserRef, otherUserRef, otherUserData);
  }

  static void _onSelfieAcceptTap(LoggedInUser loggedInUser, DocumentSnapshot otherUserData) async {
    DocumentReference loggedInUserRef = loggedInUser.getHashMap[FirestoreManager.keyDocumentReference];
    DocumentReference otherUserRef;
    await _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(loggedInUserRef, otherUserRef, otherUserData);
  }

  static _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(
      DocumentReference loggedInUserRef, DocumentReference otherUserRef, DocumentSnapshot otherUserData) async {
    await Firestore.instance
        .collection("users")
        .where(FirestoreManager.keyDisplayName, isEqualTo: otherUserData[FirestoreManager.keyDisplayName])
        .limit(1)
        .getDocuments()
        .then((snapshot) {
      otherUserRef = snapshot.documents[0].reference;
      FirestoreReadcheck.heroCreatorReads++;
      FirestoreReadcheck.heroCreatorWrites++;
      FirestoreReadcheck.printHeroCreatorReads();
      FirestoreReadcheck.printHeroCreatorWrites();
      otherUserRef.updateData({
        FirestoreManager.keyIncomingSelfieRequests: FieldValue.arrayUnion([loggedInUserRef]),
      });
    });

    await loggedInUserRef.updateData({
      FirestoreManager.keyOutgoingSelfieRequests: FieldValue.arrayUnion([otherUserRef]),
    });
  }

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }
}
