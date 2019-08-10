import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/RankCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RankingListPage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final LatLng loggedInUserLatLng;
  final List<dynamic> usersNearby;

  RankingListPage({@required this.firebaseUser, @required this.loggedInUserLatLng, @required this.usersNearby});

  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> with AutomaticKeepAliveClientMixin {
  List<Widget> friendlinessCards = List<Widget>();
  List<Widget> fameCards = List<Widget>();
  List<dynamic> sortedUsersNearbyFriendliness = List<dynamic>();
  List<dynamic> sortedUsersNearbyFame = List<dynamic>();

  @override
  void initState() {
    super.initState();
    sortedUsersNearbyFriendliness = widget.usersNearby.toList();
    sortedUsersNearbyFame = widget.usersNearby.toList();
    _sortRoomBy(sortedUsersNearbyFriendliness, 'friendliness', ascending: false);
    _sortRoomBy(sortedUsersNearbyFame, 'fame', ascending: false);
    constructCards2(friendlinessCards, Icons.sentiment_very_satisfied, sortedUsersNearbyFriendliness, 'friendliness');
    constructCards2(fameCards, Icons.star, sortedUsersNearbyFame, 'fame');
  }

  _sortRoomBy(List<Map<dynamic, dynamic>> toBeSorted, String sortByKey, {bool ascending = true}) {
    int minIndex;
    for (int i = 0; i < toBeSorted.length; i++) {
      minIndex = i;
      for (int j = i + 1; j < toBeSorted.length; j++) {
        int min = toBeSorted[minIndex][sortByKey];
        int recentJ = toBeSorted[j][sortByKey];
        if (ascending) {
          if (recentJ < min) {
            minIndex = j;
          }
        } else {
          if (recentJ > min) {
            minIndex = j;
          }
        }
      }
      // Swap min and I
      Map<dynamic, dynamic> pointerI = toBeSorted[i];
      Map<dynamic, dynamic> pointerMin = toBeSorted[minIndex];

      toBeSorted[i] = pointerMin;
      toBeSorted[minIndex] = pointerI;
    }
  }

  void constructCards2(List<Widget> cards, IconData icon, List<dynamic> sortedUsers, String valueType) {
    // Give the card a bit of gap in the beginning
    cards.add(SizedBox(width: 20.0));

    for (int i = 0; i < sortedUsers.length; i++) {
      // Now that it's ordered by the key, construct a card for everyone in the database in order
      String url = sortedUsers[i]['circleImageUrl']; // Network URL to image

      // Create the card
      RankCard card = RankCard(
        firebaseUser: widget.firebaseUser,
        documentSnapshot: sortedUsers[i]['snapshot'],
        image: url,
        name: sortedUsers[i]['displayName'],
        icon: icon,
        rarityBorder: sortedUsers[i]['rarityBorder'],
        value: sortedUsers[i][valueType],
        dotIsOn: true,
        key: UniqueKey(),
      );

      // Trigger rebuild when adding each card (bad?)
      setState(() {
        cards.add(card);
      });
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
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
