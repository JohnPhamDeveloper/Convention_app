import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/widgets/medals/medals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ActionButton.dart';

class HeroProfileDetails extends StatelessWidget {
  final bool isLoggedInUser;
  final String userCircleImage;
  final String displayName;
  final int rarityBorder;
  final int friendliness;
  final int fame;
  final Function onSelfieRequestTap;

  HeroProfileDetails({
    @required this.userCircleImage,
    @required this.onSelfieRequestTap,
    @required this.rarityBorder,
    @required this.displayName,
    @required this.friendliness,
    @required this.fame,
    this.isLoggedInUser = false,
  });

  // Render different buttons depending on if the profile
  // logged in user, photographer, cosplayer, or congoer
  Widget _renderPage(BuildContext context) {
    print(isLoggedInUser);
    if (isLoggedInUser) {
      return _renderLoggedInUserPage(context);
    }
    return _renderOtherUserPage();
  }

  _renderLoggedInUserPage(BuildContext context) {
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
                  enableSelfieDot: isLoggedInUser ? false : true,
                  statusDotOuterSize: 25.0,
                  statusDotRight: 15,
                  statusDotBottom: 10,
                  selfieDotOuterSize: 25.0,
                  selfieDotLeft: 15,
                  selfieDotBottom: 10,
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
            // Options
            ActionButton(
              fillColor: kButtonNormalFillColor,
              icon: FontAwesomeIcons.cog,
              text: Text("Options", style: kButtonNormalTextStyle),
              onTap: () {},
              iconColor: kButtonNormalIconColor,
            ),
            SizedBox(height: 25.0),
            // Logout button
            ActionButton(
              fillColor: kButtonNormalFillColor,
              icon: Icons.directions_run,
              text: Text("Log Out", style: kButtonNormalTextStyle),
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
              iconColor: kButtonNormalIconColor,
            ),
            SizedBox(height: 250),
          ],
        )
      ],
    );
  }

  _renderOtherUserPage() {
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
                  enableSelfieDot: true,
                  statusDotOuterSize: 25.0,
                  statusDotRight: 15,
                  statusDotBottom: 10,
                  selfieDotOuterSize: 25.0,
                  selfieDotLeft: 15,
                  selfieDotBottom: 10,
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
            ActionButton(
              fillColor: Colors.pinkAccent,
              icon: Icons.favorite,
              text: Text("Vote Friendly", style: kButtonActionTextStyle),
              onTap: () {},
              iconColor: Colors.white,
            ),
            SizedBox(height: 25.0),
            // Selfie request button
            ActionButton(
              fillColor: Colors.pinkAccent,
              icon: Icons.camera_alt,
              text: Text("Selfie Request", style: kButtonActionTextStyle),
              onTap: () {
                onSelfieRequestTap();
              },
              iconColor: Colors.white,
            ),
            SizedBox(height: 25.0),
            // Photography request button
            ActionButton(
              fillColor: Colors.pinkAccent,
              icon: Icons.linked_camera,
              text: Text("Photography Request", style: kButtonActionTextStyle),
              onTap: () {},
              iconColor: Colors.white,
            ),
            SizedBox(height: 250),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderPage(context);
  }
}

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
