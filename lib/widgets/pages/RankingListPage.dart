import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';

const List<NetworkImage> testImages = [
  NetworkImage(
      "https://c.pxhere.com/photos/0c/ea/china_girls_game_anime_cute_girl_japanese_costume-187567.jpg!d"),
  NetworkImage(
      "https://c.pxhere.com/photos/fc/88/boy_portrait_people_man_anime_face_35mm_comic-185839.jpg!d"),
  NetworkImage(
      "https://c.pxhere.com/photos/eb/33/china_girls_game_anime_cute_girl_japanese_costume-187564.jpg!d"),
];

const List<NetworkImage> testImages2 = [
  NetworkImage(
      "https://c.pxhere.com/photos/ff/89/girls_game_anime_cute_girl_japanese_costume_comic-187663.jpg!d"),
  NetworkImage(
      "https://c.pxhere.com/photos/bb/92/boy_portrait_people_man_anime_face_35mm_comic-185893.jpg!d"),
  NetworkImage(
      "https://c.pxhere.com/photos/fb/84/50mm_anime_comic_comiccon_cosplay_costume_cute_face-343295.jpg!d"),
];

class RankingListPage extends StatefulWidget {
  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage>
    with AutomaticKeepAliveClientMixin {
  List<Widget> friendlinessCards = List<Widget>();
  List<Widget> fameCards = List<Widget>();

  @override
  void initState() {
    super.initState();
    constructCards(friendlinessCards, FirestoreManager.keyFriendliness,
        Icons.sentiment_very_satisfied);
    constructCards(fameCards, FirestoreManager.keyFame, Icons.star);
  }

  void constructCards(List<Widget> cards, String orderBy, IconData icon) {
    // Give the card a bit of gap in the beginning
    cards.add(SizedBox(width: 20.0));
    try {
      // Go into our database and order by the key.
      Firestore.instance
          .collection("users")
          .orderBy(orderBy, descending: true)
          .getDocuments()
          .then((snapshot) {
        // Now that it's ordered by the key, construct a card for everyone in the database in order
        snapshot.documents.forEach((data) {
          String url =
              data[FirestoreManager.keyPhotos][0]; // Network URL to image

          // Create the card
          RankCard card = RankCard(
            image: url,
            name: data[FirestoreManager.keyDisplayName],
            icon: icon,
            value: data[orderBy],
            dotIsOn: true,
            key: UniqueKey(),
          );

          // Trigger rebuild when adding each card (bad?)
          setState(() {
            cards.add(card);
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          // Most Friendly
          ScrollableTitle(
            title: Text("Most Friendly", style: kCardTitleStyle),
            child: friendlinessCards,
          ),
          SizedBox(height: kCardGap + 10),
          // Highest Fame
          ScrollableTitle(
            title: Text("Highest Fame", style: kCardTitleStyle),
            child: fameCards,
          ),
//          SizedBox(height: kCardGap + 10),
//          ScrollableTitle(
//            title: Text("Most Daily Selfies(probably remove this)",
//                style: kCardTitleStyle),
//          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class RankCard extends StatelessWidget {
  final String image;
  final String name;
  final int value;
  final IconData icon;
  final bool dotIsOn;
  final Key key;
  //Icons.sentiment_very_satisfied

  RankCard(
      {@required this.image,
      this.name,
      this.icon,
      this.value,
      this.dotIsOn,
      this.key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {},
        child: Stack(
          children: <Widget>[
            ImageContainer(
                borderWidth: 3.5,
                borderRadius: 25.0,
                enableShadows: true,
                rarityBorderColor: kRarityBorders[0],
                width: 220,
                image: image),
            // Dot
            Positioned(
              right: 13,
              top: 13,
              child: Container(
                child: NotificationDot(
                  outerSize: 25.0,
                  innerSize: 25.0,
                  innerColor: dotIsOn ? Colors.pinkAccent : Colors.grey[50],
                ),
              ),
            ),
            // Bottom Left
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconText(
                    icon: Icons.face,
                    iconSize: 25.0,
                    text: Text(
                      name,
                      style: kProfileOverlayNameStyle,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  IconText(
                    icon: icon,
                    iconSize: 25.0,
                    text: Text(
                      value.toString(),
                      style: kProfileOverlayTextStyle,
                    ),
                  ),
//                  SizedBox(height: 5.0),
//                  IconText(
//                    icon: Icons.star,
//                    text: Text(
//                      "1252",
//                      style: kProfileOverlayTextStyle,
//                    ),
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle = TextStyle(
    fontSize: 17.0,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    shadows: kTextStrokeOutlines);

final Color kTextStrokeColor = Colors.black54;
final double kTextStrokeBlur = 5.0;
final List<Shadow> kTextStrokeOutlines = [
  Shadow(
// bottomLeft
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// bottomRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// topRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, 1.5),
      color: kTextStrokeColor),
  Shadow(
// topLeftblur
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, 1.5),
      color: kTextStrokeColor),
];

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Text text;

  IconText(
      {@required this.icon,
      this.iconSize = 30.0,
      @required this.text,
      this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              left: 0.2,
              top: 0.2,
              child: Icon(icon, color: Colors.black12, size: iconSize + 2.0),
            ),
            Icon(icon, color: iconColor, size: iconSize),
          ],
        ),
        SizedBox(width: 10.0),
        text
      ],
    );
  }
}
