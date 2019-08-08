import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/RankCard.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankingListPage extends StatefulWidget {
  FirebaseUser firebaseUser;

  RankingListPage({@required firebaseUser});

  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> with AutomaticKeepAliveClientMixin {
  List<Widget> friendlinessCards = List<Widget>();
  List<Widget> fameCards = List<Widget>();

  @override
  void initState() {
    super.initState();
    constructCards(friendlinessCards, FirestoreManager.keyFriendliness, Icons.sentiment_very_satisfied);
    constructCards(fameCards, FirestoreManager.keyFame, Icons.star);
  }

  void constructCards(List<Widget> cards, String orderBy, IconData icon) {
    // Give the card a bit of gap in the beginning
    cards.add(SizedBox(width: 20.0));
    try {
      // Go into our database and order by the key.
      Firestore.instance.collection("users").orderBy(orderBy, descending: true).getDocuments().then((snapshot) {
        // Now that it's ordered by the key, construct a card for everyone in the database in order
        snapshot.documents.forEach((data) {
          String url = data[FirestoreManager.keyPhotos][0]; // Network URL to image
          Key key = UniqueKey(); // Used for the dot hero animation
          String dotHeroName = key.toString() + "rankedDot";
          String imageHeroName = key.toString() + "rankedToHero";

          // Create the card
          RankCard card = RankCard(
            firebaseUser: widget.firebaseUser,
            documentSnapshot: data,
            heroName: dotHeroName,
            //imageHeroName: imageHeroName,
            image: url,
            name: data[FirestoreManager.keyDisplayName],
            icon: icon,
            rarityBorder: data[FirestoreManager.keyRarityBorder],
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

//  void onRankCardTap(Key key, DocumentSnapshot data) {
//    // Construct HeroProfile widget from the information on the clicked avatar
//    HeroProfileStart heroProfileStart =
//        HeroCreator.createHeroProfileStart(key, data);
//    HeroProfileDetails heroProfileDetails =
//        HeroCreator.createHeroProfileDetails(data);
//    Widget clickedProfile = HeroCreator.wrapInScaffold(
//        [heroProfileStart, heroProfileDetails], context);
//
//    // Push that profile into view
//    Navigator.push(
//        context, MaterialPageRoute(builder: (context) => clickedProfile));
//  }

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
