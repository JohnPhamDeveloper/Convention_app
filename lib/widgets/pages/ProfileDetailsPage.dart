import 'package:flutter/material.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';

class ProfileDetailsPage extends StatelessWidget {
//  String renderUserImage(loggedInUser) {
//    List<dynamic> imageUrls =
//        loggedInUser.getHashMap[FirestoreManager.keyPhotos];
//    if (imageUrls.isEmpty)
//      return "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Icon-round-Question_mark.svg/300px-Icon-round-Question_mark.svg.png";
//
//    return imageUrls[0];
//  }

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
