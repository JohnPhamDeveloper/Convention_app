import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

// COSPLAYER
class UserSearchInfo extends StatelessWidget {
  final String imageHeroName;
  final String backgroundImage;
  final String name;
  final String title;
  final String subtitle;
  final String cost;
  final Function onTap;
  final int rarity;
  final int friendliness;
  final Key key;

  UserSearchInfo({
    this.backgroundImage =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Icon-round-Question_mark.svg/300px-Icon-round-Question_mark.svg.png",
    this.imageHeroName = "",
    @required this.onTap,
    this.name,
    this.subtitle,
    this.title,
    this.friendliness,
    this.key,
    this.cost,
    this.rarity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            // Image
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ImageContainer(
                  heroName: imageHeroName,
                  enableTopLeftDot: true,
                  topLeftDotBottom: 2,
                  topLeftDotRight: 2,
                  borderWidth: 2.5,
                  rarityBorderColor: kRarityBorders[rarity],
                  borderRadius: 500.0,
                  image: backgroundImage,
                  width: 60.0,
                  height: 60.0),
            ),
            SizedBox(width: 20.0),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            // Friendly icon + cost
            Container(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Icon
                  Row(
                    children: <Widget>[
                      Icon(Icons.sentiment_very_satisfied,
                          color: Colors.grey[50]),
                      SizedBox(width: 5.0),
                      Text(friendliness.toString()),
                    ],
                  ),
                  SizedBox(height: 6),
                  // Cost
                  Text(
                    cost,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Photographer
class PhotographerSearchInfo extends StatelessWidget {
  final String backgroundImage;
  final String name;
  final int yearsExperience;
  final int monthsExperience;
  final String cost;
  final int friendliness;

  PhotographerSearchInfo(
      {this.backgroundImage,
      this.name,
      this.yearsExperience = 0,
      this.monthsExperience = 0,
      this.cost = "Free",
      this.friendliness});

  Text renderTextIfNoImage() {
    if (backgroundImage == null) {
      return Text("?");
    } else {
      return Text("");
    }
  }

  String renderImage() {
    if (backgroundImage == null)
      return "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Icon-round-Question_mark.svg/1024px-Icon-round-Question_mark.svg.png";
    return backgroundImage;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        print("Tapped search item");
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            // Image container
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: ImageContainer(
                  borderWidth: 2.5,
                  rarityBorderColor: kRarityBorders[0],
                  borderRadius: 500.0,
                  image: renderImage(),
                  width: 60.0,
                  height: 60.0),
            ),
            SizedBox(width: 20.0),
            // Middle information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircularBox(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6.5),
                    hasShadow: false,
                    child: Text(name,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        )),
                  ),
                  SizedBox(height: 3.0),
                  Text(
                    "${yearsExperience.toString()} year(s) and ${monthsExperience.toString()} month(s)",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    cost,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            // Friendliness
            Container(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.sentiment_very_satisfied,
                          color: Colors.grey[50]),
                      SizedBox(width: 5.0),
                      Text(friendliness.toString()),
                    ],
                  ),
                  SizedBox(height: 6),
                  CircularBox(
                    padding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    hasShadow: false,
                    child: Text(
                      "\$42/hr",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
