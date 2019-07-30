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
  static HeroProfileStart createHeroProfileStart(String dotHeroName,
      String imageHeroName, DocumentSnapshot data, bool isLoggedInUser) {
    return HeroProfileStart(
      isLoggedInUser: isLoggedInUser,
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
      DocumentSnapshot data,
      bool isLoggedInUser,
      BuildContext context,
      String loggedInUserDocumentID) {
    return HeroProfileDetails(
      onSelfieRequestTap: () {
        print(loggedInUserDocumentID);

        // getUserByDocumentID
        DocumentReference loggedInUserRef = Firestore.instance
            .collection('users')
            .document(loggedInUserDocumentID);
        print(data);
        Firestore.instance
            .collection('users')
            .document(data['documentID'])
            .setData({
          'selfieRequests': [loggedInUserRef, loggedInUserRef]
        }, merge: true);
      },
      isLoggedInUser: isLoggedInUser,
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
  static pushProfileIntoView(String dotHeroName, String imageHeroName,
      DocumentSnapshot data, BuildContext context) {
    bool isLoggedInUser = false;

    // Check if the current logged in user is the profile they're trying
    // to bring up (themselves)
    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);
    if (data[FirestoreManager.keyDisplayName] ==
        currentLoggedInUser.getHashMap[FirestoreManager.keyDisplayName]) {
      print("LOGGED IN USER FOUND ---------------------");
      isLoggedInUser = true;
    }

    HeroProfileStart heroProfileStart = HeroCreator.createHeroProfileStart(
        dotHeroName, imageHeroName, data, isLoggedInUser);

    HeroProfileDetails heroProfileDetails =
        HeroCreator.createHeroProfileDetails(data, isLoggedInUser, context,
            currentLoggedInUser.getHashMap[FirestoreManager.keyDocumentID]);
    Widget clickedProfile = HeroCreator.wrapInScaffold(
        [heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView2(HeroProfileStart start,
      HeroProfileDetails details, BuildContext context) {
    Widget clickedProfile =
        HeroCreator.wrapInScaffold([start, details], context);

    // Push that profile into view
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => clickedProfile));
  }
}
