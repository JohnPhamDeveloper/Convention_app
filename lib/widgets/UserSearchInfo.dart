import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

// COSPLAYER
class UserSearchInfo extends StatelessWidget {
  final ImageProvider backgroundImage;
  final String name;
  final String cosplayName;
  final String seriesName;
  final int friendliness;

  UserSearchInfo(
      {this.backgroundImage,
      this.name,
      this.seriesName,
      this.cosplayName,
      this.friendliness});

  Text renderTextIfNoImage() {
    if (backgroundImage == null) {
      return Text("?");
    } else {
      return Text("");
    }
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
            CircleAvatar(
              minRadius: 30.0,
              backgroundColor: Colors.blueAccent,
              child: renderTextIfNoImage(),
              backgroundImage: backgroundImage,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      )),
                  SizedBox(height: 3.0),
                  Text(
                    cosplayName,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                  SizedBox(height: 1.5),
                  Text(
                    seriesName,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50]),
                  ),
                ],
              ),
            ),
            SizedBox(width: 25.0),
            Container(
              width: 85,
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_very_satisfied, color: Colors.grey[50]),
                  SizedBox(width: 5.0),
                  Text(friendliness.toString()),
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
  final ImageProvider backgroundImage;
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
            CircleAvatar(
              minRadius: 30.0,
              backgroundColor: Colors.blueAccent,
              child: renderTextIfNoImage(),
              backgroundImage: backgroundImage,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(name,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      )),
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
            Container(
              width: 85,
              child: Row(
                children: <Widget>[
                  Icon(Icons.sentiment_very_satisfied, color: Colors.grey[50]),
                  SizedBox(width: 5.0),
                  Text(friendliness.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
