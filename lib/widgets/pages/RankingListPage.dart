import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/RankCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/widgets/ChipNavigator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';

class RankingListPage extends StatefulWidget {
  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> with AutomaticKeepAliveClientMixin {
  PageController pageController;
  PageView pageView;
  LoggedInUser loggedInUser;

  // Cards
  List<Widget> cosplayersFriendlinessCards = List<Widget>();
  List<Widget> cosplayersFameCard = List<Widget>();
  List<Widget> photographersFriendlinessCards = List<Widget>();
  List<Widget> photographersFameCards = List<Widget>();
  List<Widget> congoersFriendlinessCards = List<Widget>();
  List<Widget> congoersFameCards = List<Widget>();

  // Sorted containing map of data
  List<Map<dynamic, dynamic>> sortedCosplayersFriendliness = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> sortedCosplayersFame = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> sortedPhotographersFriendliness = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> sortedPhotographersFame = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> sortedCongoersFriendliness = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> sortedCongoersFame = List<Map<dynamic, dynamic>>();

  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggedInUser = Provider.of<LoggedInUser>(context);
    print("Didchangedepencies being caled rank list page");

    _filter(sortedCosplayersFriendliness, loggedInUser.getUsersNearby.toList(), "isCosplayer");
    _filter(sortedCosplayersFame, loggedInUser.getUsersNearby.toList(), "isCosplayer");
    _filter(sortedPhotographersFriendliness, loggedInUser.getUsersNearby.toList(), "isPhotographer");
    _filter(sortedPhotographersFame, loggedInUser.getUsersNearby.toList(), "isPhotographer");
    _filter(sortedCongoersFriendliness, loggedInUser.getUsersNearby.toList(), "isCongoer");
    _filter(sortedCongoersFame, loggedInUser.getUsersNearby.toList(), "isCongoer");

    _sortRoomBy(sortedCosplayersFriendliness, 'friendliness', ascending: false);
    _sortRoomBy(sortedCosplayersFame, 'fame', ascending: false);
    _sortRoomBy(sortedPhotographersFriendliness, 'friendliness', ascending: false);
    _sortRoomBy(sortedPhotographersFame, 'fame', ascending: false);
    _sortRoomBy(sortedCongoersFriendliness, 'friendliness', ascending: false);
    _sortRoomBy(sortedCongoersFame, 'fame', ascending: false);

    constructCards2(cosplayersFriendlinessCards, Icons.sentiment_very_satisfied, sortedCosplayersFriendliness, 'friendliness');
    constructCards2(cosplayersFameCard, Icons.star, sortedCosplayersFame, 'fame');
    constructCards2(
        photographersFriendlinessCards, Icons.sentiment_very_satisfied, sortedPhotographersFriendliness, 'friendliness');
    constructCards2(photographersFameCards, Icons.star, sortedPhotographersFame, 'fame');
    constructCards2(congoersFriendlinessCards, Icons.sentiment_very_satisfied, sortedCongoersFriendliness, 'friendliness');
    constructCards2(congoersFameCards, Icons.star, sortedCongoersFame, 'fame');

    _createPages();
  }

  _filter(List<Map<dynamic, dynamic>> copyTo, List<Map<dynamic, dynamic>> copyFrom, String filterBy) {
    copyTo.clear();
    for (int i = 0; i < copyFrom.length; i++) {
      if (copyFrom[i][filterBy] == true) {
        copyTo.add(copyFrom[i]);
      }
    }
  }

  _sortRoomBy(List<Map<dynamic, dynamic>> toBeSorted, String sortByKey, {bool ascending = true}) {
    // toBeSorted.clear();
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
    cards.clear();
    // Give the card a bit of gap in the beginning
    cards.add(SizedBox(width: 20.0));

    for (int i = 0; i < sortedUsers.length; i++) {
      // Now that it's ordered by the key, construct a card for everyone in the database in order
      String url = sortedUsers[i]['circleImageUrl']; // Network URL to image

      // Create the card
      RankCard card = RankCard(
        firebaseUser: loggedInUser.getFirebaseUser,
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

  _createPages() {
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        Section(friendlinessCards: cosplayersFriendlinessCards, fameCards: cosplayersFameCard),
        Section(friendlinessCards: photographersFriendlinessCards, fameCards: photographersFameCards),
        Section(friendlinessCards: congoersFriendlinessCards, fameCards: congoersFameCards),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: ChipNavigator(
            chipNames: <String>['Cosplayers', 'Photographers', 'Con-goers'],
            onPressed: (index) {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
            navIndex: navIndex,
          ),
        ),
        Flexible(flex: 7, child: pageView)

//        ListView(
//          children: <Widget>[
//            SizedBox(height: 20),
//            // Most Friendly
//            ScrollableTitle(
//              title: Text("Most Friendly", style: kCardTitleStyle),
//              child: friendlinessCards,
//            ),
//            SizedBox(height: kCardGap + 10),
//            // Highest Fame
//            ScrollableTitle(
//              title: Text("Highest Fame", style: kCardTitleStyle),
//              child: fameCards,
//            ),
//            SizedBox(height: 100),
//          ],
//        ),
      ],
    );
  }
}

class Section extends StatelessWidget {
  final List<Widget> friendlinessCards;
  final List<Widget> fameCards;

  Section({@required this.friendlinessCards, @required this.fameCards});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}
