import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/MiniUser.dart';

// COSPLAYER
class UserSearchInfo extends StatefulWidget {
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
    this.name = "empty",
    this.subtitle = "",
    this.title = "empty",
    this.friendliness = 0,
    this.key,
    this.cost = "?",
    this.rarity,
  }) : super(key: key);

  @override
  _UserSearchInfoState createState() => _UserSearchInfoState();
}

class _UserSearchInfoState extends State<UserSearchInfo> {
  bool _isLoggedInUser = false;
//  Color _selfieDotColor = Colors.pinkAccent;

  renderSubtitle() {
    if (widget.subtitle.isNotEmpty) {
      return Text(
        widget.subtitle,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white),
      );
    }
    return Container(width: 0, height: 0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if the user is the logged in user
    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);
    if (widget.name == currentLoggedInUser.getHashMap[FirestoreManager.keyDisplayName]) {
      //  print("LOGGED IN USER FOUND ---------------------");
      _isLoggedInUser = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey[100],
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
        child: Row(
          children: <Widget>[
            // Image
            MiniUser(
              width: 63.0,
              height: 63.0,
              imageHeroName: widget.imageHeroName,
              enableSelfieDot: !_isLoggedInUser,
              rarity: widget.rarity,
              imageURL: widget.backgroundImage,
            ),
//            Padding(
//              padding: const EdgeInsets.only(bottom: 0.0),
//              child: ImageContainer(
//                  heroName: widget.imageHeroName,
//                  enableStatusDot: true,
//                  enableSelfieDot: !_isLoggedInUser,
//                  selfieDotInnerColor: Colors.pinkAccent,
//                  selfieDotLeft: 0,
//                  selfieDotBottom: 2,
//                  statusDotBottom: 2,
//                  statusDotRight: 2,
//                  borderWidth: 2.5,
//                  rarityBorderColor: kRarityBorders[widget.rarity],
//                  borderRadius: 500.0,
//                  image: widget.backgroundImage,
//                  width: 60.0,
//                  height: 60.0),
//            ),
            SizedBox(width: 20.0),
            // Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.0),
                  // title
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.white),
                  ),
                  SizedBox(height: 1.5),
                  // subtitle
                  renderSubtitle(),
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
                      Icon(Icons.sentiment_very_satisfied, color: Colors.grey[50]),
                      SizedBox(width: 5.0),
                      Text(widget.friendliness.toString()),
                    ],
                  ),
                  SizedBox(height: 6),
                  // Cost
                  Text(
                    widget.cost,
                    style: TextStyle(color: Colors.white, fontSize: 11.0, fontWeight: FontWeight.w700),
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

//// Photographer
//class PhotographerSearchInfo extends StatelessWidget {
//  final String backgroundImage;
//  final String name;
//  final int yearsExperience;
//  final int monthsExperience;
//  final String cost;
//  final int friendliness;
//
//  PhotographerSearchInfo(
//      {this.backgroundImage,
//      this.name,
//      this.yearsExperience = 0,
//      this.monthsExperience = 0,
//      this.cost = "Free",
//      this.friendliness});
//
//  Text renderTextIfNoImage() {
//    if (backgroundImage == null) {
//      return Text("?");
//    } else {
//      return Text("");
//    }
//  }
//
//  String renderImage() {
//    if (backgroundImage == null)
//      return "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Icon-round-Question_mark.svg/1024px-Icon-round-Question_mark.svg.png";
//    return backgroundImage;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      splashColor: Colors.grey[100],
//      onTap: () {
//        print("Tapped search item");
//      },
//      child: Padding(
//        padding: const EdgeInsets.only(left: 16.0, right: 0.0, bottom: 8.0, top: 8.0),
//        child: Row(
//          children: <Widget>[
//            // Image container
//            Padding(
//              padding: const EdgeInsets.only(bottom: 0.0),
//              child: ImageContainer(
//                  borderWidth: 2.5,
//                  rarityBorderColor: kRarityBorders[0],
//                  borderRadius: 500.0,
//                  imageURL: renderImage(),
//                  width: 60.0,
//                  height: 60.0),
//            ),
//            SizedBox(width: 20.0),
//            // Middle information
//            Expanded(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  CircularBox(
//                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6.5),
//                    hasShadow: false,
//                    child: Text(name,
//                        style: TextStyle(
//                          fontSize: 15.0,
//                          fontWeight: FontWeight.w500,
//                          color: Colors.black87,
//                        )),
//                  ),
//                  SizedBox(height: 3.0),
//                  Text(
//                    "${yearsExperience.toString()} year(s) and ${monthsExperience.toString()} month(s)",
//                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[50]),
//                  ),
//                  SizedBox(height: 1.5),
//                  Text(
//                    cost,
//                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, color: Colors.grey[50]),
//                  ),
//                ],
//              ),
//            ),
//            SizedBox(width: 25.0),
//            // Friendliness
//            Container(
//              width: 85,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Icon(Icons.sentiment_very_satisfied, color: Colors.grey[50]),
//                      SizedBox(width: 5.0),
//                      Text(friendliness.toString()),
//                    ],
//                  ),
//                  SizedBox(height: 6),
//                  CircularBox(
//                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
//                    hasShadow: false,
//                    child: Text(
//                      "\$42/hr",
//                      style: TextStyle(color: Colors.black87, fontSize: 11.0, fontWeight: FontWeight.w700),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
