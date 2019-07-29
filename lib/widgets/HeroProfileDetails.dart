import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/widgets/RoundButtonTextIcon.dart';
import 'package:cosplay_app/widgets/medals/medals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';

class HeroProfileDetails extends StatelessWidget {
  final String userCircleImage;
  final String displayName;
  final int rarityBorder;
  final int friendliness;
  final int fame;

  HeroProfileDetails(
      {@required this.userCircleImage,
      @required this.rarityBorder,
      @required this.displayName,
      @required this.friendliness,
      @required this.fame});

  // Render different things here depending on whether the details
  // page is the user, other users, photographer, etc...

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            // user image
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ImageContainer(
                  enableStatusDot: true,
                  statusDotOuterSize: 25.0,
                  statusDotRight: 15,
                  statusDotBottom: 10,
                  borderWidth: 3.5,
                  rarityBorderColor: kRarityBorders[rarityBorder],
                  borderRadius: 500.0,
                  image: userCircleImage,
                  width: 160.0,
                  height: 160.0),
            ),
            SizedBox(height: 20.0),
            // Name
            Text(
              displayName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0),
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RoundButton(
                    size: 45.0,
                    icon: FontAwesomeIcons.instagram,
                    iconSize: 25.0,
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
                SizedBox(width: 20.0),
                RoundButton(
                    size: 45.0,
                    icon: FontAwesomeIcons.twitter,
                    iconSize: 25.0,
                    padding: EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
              ],
            ),
            SizedBox(height: 30.0),
            // Friendliness
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleData(
                    title: "Friendliness", number: friendliness, width: 150.0),
                SizedBox(width: 30),
                TitleData(title: "Fame", number: fame, width: 150.0)
              ],
            ),
            SizedBox(height: 30.0),
            // Medals
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
            SizedBox(height: 40.0),
            // Vote friendly button
            Padding(
              padding: const EdgeInsets.only(
                  left: kButtonPaddingLeft, right: kButtonPaddingRight),
              child: RoundButtonTextIcon(
                  text: Text("Vote Friendly", style: kButtonActionTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.favorite,
                  iconColor: Colors.white,
                  onTap: () {}),
            ),
            SizedBox(height: 25.0),
            // Selfie request button
            Padding(
              padding: const EdgeInsets.only(
                  left: kButtonPaddingLeft, right: kButtonPaddingRight),
              child: RoundButtonTextIcon(
                  text: Text("Selfie Request", style: kButtonActionTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.camera_alt,
                  iconColor: Colors.white,
                  onTap: () {
                    // print("TEST");
                  }),
            ),
            SizedBox(height: 25.0),
            // Photography request button
            Padding(
              padding: const EdgeInsets.only(
                  left: kButtonPaddingLeft, right: kButtonPaddingRight),
              child: RoundButtonTextIcon(
                  text: Text("Photography Request",
                      style: kButtonActionTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.linked_camera,
                  iconColor: Colors.white,
                  onTap: () async {
                    print("Logging Out");
                    FirebaseUser user =
                        await FirebaseAuth.instance.currentUser();
                    print(user.email);
                    print(user.isEmailVerified);
                    print(user.displayName);
                    try {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "/");
                    } catch (e) {
                      print(e);
                    }
                  }),
            ),
            SizedBox(height: 25.0),
            // Options
            Padding(
              padding: const EdgeInsets.only(
                  left: kButtonPaddingLeft, right: kButtonPaddingRight),
              child: RoundButtonTextIcon(
                  text: Text("Options", style: kButtonNormalTextStyle),
                  fillColor: kButtonNormalFillColor,
                  icon: FontAwesomeIcons.cog,
                  iconColor: kButtonNormalIconColor,
                  onTap: () {
                    //print("TEST");
                  }),
            ),
            SizedBox(height: 25.0),
            // Logout button
            Padding(
              padding: const EdgeInsets.only(
                  left: kButtonPaddingLeft, right: kButtonPaddingRight),
              child: RoundButtonTextIcon(
                text: Text("Log Out", style: kButtonNormalTextStyle),
                fillColor: kButtonNormalFillColor,
                icon: Icons.directions_run,
                iconColor: kButtonNormalIconColor,
                onTap: () async {
                  print("Logging Out");
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();

                  // They were not signed in the first place (how did the get in?)
                  if (user == null) Navigator.pushNamed(context, '/');

                  print(user.email);
                  print(user.isEmailVerified);
                  print(user.displayName);
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/");
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ),
            SizedBox(height: 250),
          ],
        )
      ],
    );
  }
}

// Both buttons
const double kButtonPaddingLeft = 30.0;
const double kButtonPaddingRight = 30.0;

// Pink buttons
const TextStyle kButtonActionTextStyle =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.white);

// White buttons
const TextStyle kButtonNormalTextStyle = TextStyle(
    fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.black54);
const kButtonNormalFillColor = Colors.white;
const kButtonNormalIconColor = Colors.black54;

// Column widget which displays a title on top and an number on bottom
class TitleData extends StatelessWidget {
  final String title;
  final int number;
  final double width;

  TitleData({@required this.title, @required this.number, this.width});

  String convertNumberToString() {
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CircularBox(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.0),
          Text(
            convertNumberToString(),
            style: TextStyle(
                fontSize: 25.0,
                color: Colors.cyan[300],
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
