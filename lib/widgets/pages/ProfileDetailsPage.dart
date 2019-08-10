import 'package:flutter/material.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';

// This is the profile for the logged in user when they click the profile
// selection in the bottom nav bar
class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Gets updated everytime loggedInUser changes
    return Consumer<LoggedInUser>(builder: (context, loggedInUser, child) {
      return HeroProfileDetails(
        displayAcceptButton: false,
        displayFinishButton: false,
        displayRequestButton: false,
        isLoggedInUser: true,
        onSelfieRequestTap: () {},
        onSelfieFinishTap: () {},
        onSelfieAcceptTap: () {},
        userCircleImage: loggedInUser.getHashMap[FirestoreManager.keyPhotos][0],
        rarityBorder: loggedInUser.getHashMap[FirestoreManager.keyRarityBorder],
        displayName: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
        friendliness: loggedInUser.getHashMap[FirestoreManager.keyFriendliness],
        fame: loggedInUser.getHashMap[FirestoreManager.keyFame],
      );
    });
  }
}
