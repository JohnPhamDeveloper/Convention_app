import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

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
  @override
  void initState() {
    super.initState();
//    Firestore.instance.collection("users").orderBy(
//        FirestoreManager.keyFriendliness, descending: true)
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
            images: testImages,
          ),
          SizedBox(height: kCardGap + 10),
          // Highest Fame
          ScrollableTitle(
            title: Text("Highest Fame", style: kCardTitleStyle),
            images: testImages2,
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
