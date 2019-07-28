import 'package:flutter/material.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedInUser>(builder: (context, loggedInUser, child) {
      return HeroProfileDetails(
        userCircleImage: loggedInUser.getHashMap[FirestoreManager.keyPhotos][0],
        rarityBorder: loggedInUser.getHashMap[FirestoreManager.keyRarityBorder],
        displayName: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
        friendliness: loggedInUser.getHashMap[FirestoreManager.keyFriendliness],
        fame: loggedInUser.getHashMap[FirestoreManager.keyFame],
      );
    });
  }
}
