import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

const double kMedalSize = 18.0;

void onMedalClick(
    BuildContext context, String medalName, String medalDescription) {
  Alert(
          style: AlertStyle(),
          type: AlertType.info,
          context: context,
          title: medalName,
          buttons: [
            DialogButton(
              radius: BorderRadius.circular(20.0),
              child: Text(
                "Awesome",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: Colors.cyan[300],
            )
          ],
          desc: medalDescription)
      .show();
}

class TrustMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Trust Medal",
            "The developer finds this person trustworthy!");
      },
      icon: FontAwesomeIcons.handHoldingHeart,
      iconSize: kMedalSize,
      iconColor: Colors.redAccent,
    );
  }
}

class MetDeveloperMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(
            context, "Met Developer Medal", "Met the developer in person!");
      },
      icon: Icons.laptop_windows,
      // padding: EdgeInsets.only(left: 16, right: 21, top: 16, bottom: 18),
      iconSize: kMedalSize,
    );
  }
}

class PurpleHeartMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Purple Heart Medal",
            "Perosonally awarded to those who helped other unselfishly!");
      },
      icon: FontAwesomeIcons.medal,
      iconSize: kMedalSize,
      iconColor: Colors.purpleAccent,
    );
  }
}

class VerifiedPhoneMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Verified Phone Medal",
            "This person has verified their phone number!");
      },
      icon: FontAwesomeIcons.check,
      iconSize: kMedalSize,
      iconColor: Colors.greenAccent,
    );
  }
}

class HundredSelfieMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(
            context, "100 Selfie Medal", "This person took 100 selfies, wow!");
      },
      icon: FontAwesomeIcons.camera,
      iconSize: kMedalSize,
      iconColor: Colors.deepPurpleAccent,
    );
  }
}

class ThreeHundredSelfieMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "300 Selfie Medal",
            "This person took 300 selfies, incredible!");
      },
      icon: FontAwesomeIcons.cameraRetro,
      iconSize: kMedalSize,
      iconColor: Colors.teal,
    );
  }
}

class FriendlyHundredMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Friendly Medal",
            "This user has been rated friendly 100 times!");
      },
      icon: FontAwesomeIcons.handPeace,
      iconSize: kMedalSize,
      iconColor: Colors.redAccent,
    );
  }
}

class FriendlyTwoHundredMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Super Friendly Medal",
            "This user has been rated friendly 200 times!");
      },
      icon: FontAwesomeIcons.dove,
      iconSize: kMedalSize,
      iconColor: Colors.orangeAccent,
    );
  }
}

class FriendlyFiveHundredMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Mega Friendly Medal",
            "This user has been rated friendly 500 times!");
      },
      icon: FontAwesomeIcons.kiss,
      iconSize: kMedalSize,
      iconColor: Colors.deepPurple,
    );
  }
}

class FiftySelfieWithOnePersonMedal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundButton(
      onTap: () {
        onMedalClick(context, "Good Friends Medal",
            "This user took 50 selfies with one person! Maybe they're friends now!");
      },
      icon: FontAwesomeIcons.peopleCarry,
      iconSize: kMedalSize,
      iconColor: Colors.indigoAccent,
    );
  }
}
