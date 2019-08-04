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
import 'package:rflutter_alert/rflutter_alert.dart';

class HeroProfileDetails extends StatefulWidget {
  final bool isLoggedInUser;
  final String userCircleImage;
  final String displayName;
  final int rarityBorder;
  final int friendliness;
  final int fame;
  final Function onSelfieRequestTap;
  final Function onSelfieAcceptTap;
  final Function onSelfieFinishTap;
  final bool displayFinishButton;
  final bool displayAcceptButton;
  final bool displayRequestButton;

  HeroProfileDetails({
    @required this.userCircleImage,
    @required this.onSelfieAcceptTap,
    @required this.displayFinishButton,
    @required this.displayRequestButton,
    @required this.displayAcceptButton,
    @required this.onSelfieFinishTap,
    @required this.onSelfieRequestTap,
    @required this.rarityBorder,
    @required this.displayName,
    @required this.friendliness,
    @required this.fame,
    this.isLoggedInUser = false,
  });

  @override
  _HeroProfileDetailsState createState() => _HeroProfileDetailsState();
}

class _HeroProfileDetailsState extends State<HeroProfileDetails> {
  bool _clickedOnSelfieRequestButton = false;
  bool _clickedOnAcceptSelfieButton = false;
  bool _clickedOnFinishSelfieButton = false;

  Widget _renderPage(BuildContext context) {
    print(widget.isLoggedInUser);
    if (widget.isLoggedInUser) {
      return _renderLoggedInUserPage(context);
    }
    return _renderOtherUserPage(context);
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
                  enableSelfieDot: widget.isLoggedInUser ? false : true,
                  statusDotOuterSize: 25.0,
                  statusDotRight: 15,
                  statusDotBottom: 10,
                  selfieDotOuterSize: 25.0,
                  selfieDotLeft: 15,
                  selfieDotBottom: 10,
                  borderWidth: 3.5,
                  rarityBorderColor: kRarityBorders[widget.rarityBorder],
                  borderRadius: 500.0,
                  imageURL: widget.userCircleImage,
                  width: 160.0,
                  height: 160.0),
            ),
            SizedBox(height: 20.0),
            // Name
            Text(
              widget.displayName,
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
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
                SizedBox(width: 20.0),
                RoundButton(
                    size: 45.0,
                    icon: FontAwesomeIcons.twitter,
                    iconSize: 25.0,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
              ],
            ),
            SizedBox(height: 30.0),
            // Friendliness
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleData(title: "Friendliness", number: widget.friendliness, width: 150.0),
                SizedBox(width: 30),
                TitleData(title: "Fame", number: widget.fame, width: 150.0)
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

  _renderOtherUserPage(BuildContext context) {
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
                  rarityBorderColor: kRarityBorders[widget.rarityBorder],
                  borderRadius: 500.0,
                  imageURL: widget.userCircleImage,
                  width: 160.0,
                  height: 160.0),
            ),
            SizedBox(height: 20.0),
            // Name
            Text(
              widget.displayName,
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
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
                SizedBox(width: 20.0),
                RoundButton(
                    size: 45.0,
                    icon: FontAwesomeIcons.twitter,
                    iconSize: 25.0,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 7.1),
                    onTap: () {}),
              ],
            ),
            SizedBox(height: 30.0),
            // Friendliness
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleData(title: "Friendliness", number: widget.friendliness, width: 150.0),
                SizedBox(width: 30),
                TitleData(title: "Fame", number: widget.fame, width: 150.0)
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
            _renderSelfieButton(context),
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

  _renderSelfieButton(BuildContext context) {
    // Greyed out buttons (these buttons change dynamically when the user press the buttons)
    if (_clickedOnSelfieRequestButton ||
        !widget.displayFinishButton && !widget.displayRequestButton && !widget.displayAcceptButton) {
      return _selfieButtonWrapper("Requested Selfie", () {}, fillColor: Colors.grey[300]);
    } else if (_clickedOnAcceptSelfieButton) {
      return _selfieButtonWrapper("Finish/Cancel Selfie", () {
        _showFinishedSelfieOptions(context);
      });
    }
    // Buttons that load up first time into details page
    else if (!widget.displayFinishButton && widget.displayRequestButton && !widget.displayAcceptButton) {
      return _selfieButtonWrapper("Request Selfie", () {
        widget.onSelfieRequestTap();
        setState(() {
          _clickedOnSelfieRequestButton = true;
        });
      });
    } else if (!widget.displayFinishButton && !widget.displayRequestButton && widget.displayAcceptButton) {
      return _selfieButtonWrapper("Accept Selfie", () {
        widget.onSelfieAcceptTap();
        setState(() {
          _clickedOnAcceptSelfieButton = true;
        });
      });
    } else if (widget.displayFinishButton && !widget.displayRequestButton && !widget.displayAcceptButton) {
      return _selfieButtonWrapper("Finish/Cancel Selfie", () {
        _showFinishedSelfieOptions(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _renderPage(context);
  }

  // PRIVATES

  _showFinishedSelfieOptions(BuildContext context) {
    Alert(
            style: AlertStyle(
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500),
                alertBorder: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            type: AlertType.info,
            context: context,
            title: "Done with selfie?",
            buttons: [
              DialogButton(
                width: 190.0,
                height: 40.0,
                radius: BorderRadius.circular(20.0),
                child: Text(
                  "Finish Selfie",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  // TODO this one sends a confirmation to the other user to tell them to verify the selfie request

                  Navigator.pop(context);
                },
                color: Colors.cyan[300],
              ),
              DialogButton(
                width: 190.0,
                height: 40.0,
                radius: BorderRadius.circular(20.0),
                child: Text(
                  "Cancel Selfie",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  widget.onSelfieFinishTap();
                  Navigator.pop(context);
                },
                color: Colors.cyan[300],
              ),
            ],
            desc: "Finishing will send a verification to confirm your selfie with the other person!")
        .show();
  }

  // Wrapper to prevent duplicate fields for selfie button
  _selfieButtonWrapper(String text, Function onTap, {Color fillColor = Colors.pinkAccent}) {
    return ActionButton(
      fillColor: fillColor,
      icon: Icons.camera_alt,
      text: Text(text, style: kButtonActionTextStyle),
      onTap: () {
        onTap();
      },
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
