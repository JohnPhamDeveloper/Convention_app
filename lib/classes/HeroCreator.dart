import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

// Used for creating the hero widgets to show the selected user's profile
// into view
class HeroCreator {
  // Creates the two pages
  // Start is the first page and Details is the second page
  static HeroProfileStart createHeroProfileStart(
      String dotHeroName, String imageHeroName, DocumentSnapshot data) {
    return HeroProfileStart(
      heroName: dotHeroName,
      imageHeroName: imageHeroName,
      userImages: data[FirestoreManager.keyPhotos],
      name: data[FirestoreManager.keyDisplayName],
      friendliness: data[FirestoreManager.keyFriendliness],
      fame: data[FirestoreManager.keyFame],
      bottomLeftItemPadding: EdgeInsets.only(left: 20, bottom: 25),
    );
  }

  static HeroProfileDetails createHeroProfileDetails(DocumentSnapshot data) {
    return HeroProfileDetails(
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
    HeroProfileStart heroProfileStart =
        HeroCreator.createHeroProfileStart(dotHeroName, imageHeroName, data);
    HeroProfileDetails heroProfileDetails =
        HeroCreator.createHeroProfileDetails(data);
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
