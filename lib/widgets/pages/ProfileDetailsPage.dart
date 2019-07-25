import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/widgets/CircularBox.dart';
import 'package:cosplay_app/widgets/RoundButtonTextIcon.dart';
import 'package:cosplay_app/widgets/medals/medals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(height: 40.0),
            ImageContainer(
                borderRadius: 500.0, path: "assets/1.jpg", size: 160.0),
            SizedBox(height: 20.0),
            Text(
              "Jason Chemry",
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
            SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleData(title: "Friendliness", number: 1252, width: 150.0),
                SizedBox(width: 30),
                TitleData(title: "Fame", number: 32222, width: 150.0)
              ],
            ),
            SizedBox(height: 50.0),
            // Medals
            CircularBox(
              child: Column(
                children: <Widget>[
                  Text(
                    "Medals",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
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
            SizedBox(height: 50.0),
            // Vote friendly button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RoundButtonTextIcon(
                  text: Text("Vote Friendly", style: kButtonBoldedTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.favorite,
                  iconColor: Colors.white,
                  onTap: () {
                    print("TEST");
                  }),
            ),
            SizedBox(height: 25.0),
            // Selfie request button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RoundButtonTextIcon(
                  text: Text("Selfie Request", style: kButtonBoldedTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.camera_alt,
                  iconColor: Colors.white,
                  onTap: () {
                    print("TEST");
                  }),
            ),
            SizedBox(height: 25.0),
            // Options
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RoundButtonTextIcon(
                  text: Text("Options", style: kButtonBoldedTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: FontAwesomeIcons.cog,
                  iconColor: Colors.white,
                  onTap: () {
                    print("TEST");
                  }),
            ),

            SizedBox(height: 25.0),
            // Photography request button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RoundButtonTextIcon(
                  text: Text("Photographer Request",
                      style: kButtonBoldedTextStyle),
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
            // Logout button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: RoundButtonTextIcon(
                  text: Text("Log Out", style: kButtonBoldedTextStyle),
                  fillColor: Colors.pinkAccent,
                  icon: Icons.directions_run,
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
            SizedBox(height: 250),
          ],
        ),
      ],
    );
  }
}

const TextStyle kButtonBoldedTextStyle =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 25.0, color: Colors.white);

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
              color: Colors.black87,
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
