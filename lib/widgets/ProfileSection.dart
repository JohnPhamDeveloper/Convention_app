import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/widgets/medals/medals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ActionButton.dart';
import 'package:cosplay_app/widgets/TitleData.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

class ProfileSection extends StatelessWidget {
  final bool isLoggedInUser;
  final int rarityBorder;
  final String userCircleImage;
  final String displayName;
  final int friendliness;
  final int fame;

  ProfileSection(
      {@required this.isLoggedInUser,
      @required this.rarityBorder,
      @required this.userCircleImage,
      @required this.displayName,
      @required this.friendliness,
      @required this.fame});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        //SizedBox(height: 25.0),
        // Friendliness
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleData(title: "Friendliness", number: friendliness, width: 150.0),
            SizedBox(width: 30),
            TitleData(title: "Fame", number: fame, width: 150.0)
          ],
        ),
        //SizedBox(height: 30.0),
        // Medals
        // TODO REMOVE OR LEAVE MEDALS
        CircularBox(
          child: Column(
            children: <Widget>[
              Text(
                "Medals",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Wrap(
                  runAlignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 15.0,
                  spacing: 15.0,
                  children: <Widget>[
                    TrustMedal(),
                    MetDeveloperMedal(),
                    PurpleHeartMedal(),
                    VerifiedPhoneMedal(),
                    HundredSelfieMedal(),
                    ThreeHundredSelfieMedal(),
                    FriendlyHundredMedal(),
                    FriendlyTwoHundredMedal(),
                    FriendlyFiveHundredMedal(),
                    FiftySelfieWithOnePersonMedal(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // BIO
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 15.0),
//              child: CircularBox(
//                child: Column(
//                  children: <Widget>[
//                    Text(
//                      "Bio",
//                      style: TextStyle(
//                        fontSize: 18.0,
//                        color: Colors.black54,
//                        fontWeight: FontWeight.w600,
//                      ),
//                    ),
//                    SizedBox(height: 15.0),
//                    Padding(
//                      padding: const EdgeInsets.only(bottom: 8.0),
//                      child: Text(
//                        "Is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
//                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400),
//                        textAlign: TextAlign.center,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
      ],
    );
  }
}

// Pink buttons
const TextStyle kButtonActionTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.white);

// Disabled
final TextStyle kButtonDisabledTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.grey[300]);
const kButtonNormalFillColor = Colors.white;
const kButtonNormalIconColor = Colors.black54;

// White buttons
const TextStyle kButtonNormalTextStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.black54);
