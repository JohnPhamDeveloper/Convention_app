import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:cosplay_app/classes/HeroCreator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchSectionItem extends StatefulWidget {
  //final String userType;
  final FirebaseUser firebaseUser;
  final LatLng loggedInUserLatLng;
  final List<Map<dynamic, dynamic>> usersNearby;

  SearchSectionItem({@required this.firebaseUser, @required this.loggedInUserLatLng, @required this.usersNearby});

  @override
  _SearchSectionItemState createState() => _SearchSectionItemState();
}

class _SearchSectionItemState extends State<SearchSectionItem> with AutomaticKeepAliveClientMixin {
  List<Widget> searchInfoWidgets = List<Widget>();
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.usersNearby.length; i++) {
      _createOneSearchUser(widget.firebaseUser, widget.usersNearby[i]);
    }
    setState(() {
      searchInfoWidgets.add(SizedBox(height: 90.0));
    });
  }

  void _createOneSearchUser(FirebaseUser firebaseUser, Map<dynamic, dynamic> cosplayersNearby) {
    SearchUserItem widget = SearchUserItem(
      backgroundImage: cosplayersNearby['circleImageUrl'],
      name: cosplayersNearby['displayName'],
      title: cosplayersNearby['cosplayName'],
      subtitle: cosplayersNearby['seriesName'],
      friendliness: cosplayersNearby['friendliness'],
      cost: '${cosplayersNearby['distance'].toStringAsFixed(1)} miles',
      rarity: cosplayersNearby['rarityBorder'],
      onTap: () {
        HeroCreator.pushProfileIntoView(cosplayersNearby['snapshot'].reference, context, firebaseUser);
      },
      key: UniqueKey(),
    );
    searchInfoWidgets.add(widget);
  }

//  void createSearchUsers(BuildContext context, FirebaseUser firebaseUser) {
//    LoggedInUser user = LoggedInUser();
//
//    // NEW
//
//    // TODO should only get user around the radius of the user
//    // Call cloud function which goes to location and pulls up all docId in 3 mile radius... (subscribe up to 10 miles)
//    // Then use those documents to pull up the public information of everyone in 0.5 mile increments (rounded down)
//    Firestore.instance.collection("users").getDocuments().then((snapshot) {
//      // Go through each user in the database
//      snapshot.documents.forEach((docSnapshot) {
//        FirestoreReadcheck.searchInfoPageReads++;
//        FirestoreReadcheck.printSearchInfoPageReads();
//        // Go through all data for the current user and put into our user object
//        docSnapshot.data.forEach((key, value) {
//          user.getHashMap[key] = value;
//        });
//
//        // TODO get rid of years and months cosplay and cosplay cost
//        bool isCosplayer = user.getHashMap[FirestoreManager.keyIsCosplayer];
//        bool isPhotographer = user.getHashMap[FirestoreManager.keyIsPhotographer];
//        String circleImageUrl = user.getHashMap[FirestoreManager.keyPhotos][0];
//        String name = user.getHashMap[FirestoreManager.keyDisplayName];
//        String subtitle = user.getHashMap[FirestoreManager.keySeriesName];
//        String title = user.getHashMap[FirestoreManager.keyCosplayName];
//        int friendliness = user.getHashMap[FirestoreManager.keyFriendliness];
//        String cosplayerCost = user.getHashMap[FirestoreManager.keyCosplayerCost];
//        String photographerCost = user.getHashMap[FirestoreManager.keyPhotographerCost];
//        int rarity = user.getHashMap[FirestoreManager.keyRarityBorder];
//        int photographyYears = user.getHashMap[FirestoreManager.keyPhotographyYearsExperience];
//        int photographyMonths = user.getHashMap[FirestoreManager.keyPhotographyMonthsExperience];
//
//        // Handle cosplayer data
//        if (widget.userType == FirestoreManager.keyIsCosplayer && isCosplayer) {
//          // store that users information into the widget
//          SearchUserItem widget = SearchUserItem(
//            backgroundImage: circleImageUrl,
//            name: name,
//            subtitle: subtitle,
//            title: title,
//            friendliness: friendliness,
//            cost: cosplayerCost,
//            rarity: rarity,
//            onTap: () {
//              HeroCreator.pushProfileIntoView(docSnapshot.reference, context, firebaseUser);
//            },
//            key: UniqueKey(),
//          );
//          searchInfoWidgets.add(widget);
//        }
//        // Handle photographer data
//        else if (widget.userType == FirestoreManager.keyIsPhotographer && isPhotographer) {
//          createDataForPhotographer(
//            circleImageUrl,
//            name,
//            photographyYears,
//            photographyMonths,
//            friendliness,
//            photographerCost,
//            rarity,
//            docSnapshot,
//            context,
//          );
//        }
//      });
//      // done storing all of users information, now we can setState to rebuild
//      // and display it
//      setState(() {
//        searchInfoWidgets.add(SizedBox(height: 90.0));
//      });
//    });
//  }

  createDataForPhotographer(
    String circleImageUrl,
    String name,
    int photographyYears,
    int photographyMonths,
    int friendliness,
    String photographerCost,
    int rarity,
    DocumentSnapshot docSnapshot,
    BuildContext context,
  ) {
    SearchUserItem widget = SearchUserItem(
      backgroundImage: circleImageUrl,
      name: name,
      subtitle: "",
      title: '$photographyYears year(s) and $photographyMonths month(s)',
      friendliness: friendliness,
      cost: photographerCost,
      rarity: rarity,
      onTap: () {
        //HeroCreator.pushProfileIntoView(docSnapshot.reference, context);
      },
      key: UniqueKey(),
    );
    searchInfoWidgets.add(widget);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: searchInfoWidgets.length,
      itemBuilder: (context, index) {
        return searchInfoWidgets[index];
      },
    );
  }
}
