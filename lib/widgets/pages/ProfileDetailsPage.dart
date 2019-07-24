import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class ProfileDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 40.0),
        ImageContainer(
            borderRadius: 500.0,
            path: "assets/1.jpg",
            width: 180.0,
            height: 180.0),
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
      ],
    );
  }
}
