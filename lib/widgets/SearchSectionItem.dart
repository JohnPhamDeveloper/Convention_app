import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:cosplay_app/classes/HeroCreator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

class SearchSectionItem extends StatefulWidget {
  final String userType;

  SearchSectionItem({@required this.userType});

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
    createSearchUsers(context);
  }

  // Initial creation of search users on app launch
  void createSearchUsers(BuildContext context) {
    // Go through every person in the users (though we'll change this to users around us)
    // Check if they are a cosplayer, if they are, then put into cosplayer list
    //List<LoggedInUser> userList = List<LoggedInUser>();
    LoggedInUser user = LoggedInUser();

    // TODO should only get user around the radius of the user
    //
    //
    //
    //
    //
    Firestore.instance.collection("users").getDocuments().then((snapshot) {
      // Go through each user in the database

      snapshot.documents.forEach((docSnapshot) {
        FirestoreReadcheck.searchInfoPageReads++;
        FirestoreReadcheck.printSearchInfoPageReads();
        // Go through all data for the current user and put into our user object
        docSnapshot.data.forEach((key, value) {
          user.getHashMap[key] = value;
        });
        // Copy each data into user object
        String key = UniqueKey().toString();
        String dotHeroName = key + 'dot';
        String imageHeroName = key + "searchHeroImage";

        // All of the data in our database
        bool isCosplayer = user.getHashMap[FirestoreManager.keyIsCosplayer];
        bool isPhotographer = user.getHashMap[FirestoreManager.keyIsPhotographer];
        String circleImageUrl = user.getHashMap[FirestoreManager.keyPhotos][0];
        String name = user.getHashMap[FirestoreManager.keyDisplayName];
        String subtitle = user.getHashMap[FirestoreManager.keySeriesName];
        String title = user.getHashMap[FirestoreManager.keyCosplayName];
        int friendliness = user.getHashMap[FirestoreManager.keyFriendliness];
        String cosplayerCost = user.getHashMap[FirestoreManager.keyCosplayerCost];
        String photographerCost = user.getHashMap[FirestoreManager.keyPhotographerCost];
        int rarity = user.getHashMap[FirestoreManager.keyRarityBorder];
        int photographyYears = user.getHashMap[FirestoreManager.keyPhotographyYearsExperience];
        int photographyMonths = user.getHashMap[FirestoreManager.keyPhotographyMonthsExperience];

        // Handle cosplayer data
        if (widget.userType == FirestoreManager.keyIsCosplayer && isCosplayer) {
          // store that users information into the widget
          UserSearchInfo widget = UserSearchInfo(
            backgroundImage: circleImageUrl,
            name: name,
            subtitle: subtitle,
            title: title,
            friendliness: friendliness,
            cost: cosplayerCost,
            rarity: rarity,
            onTap: () {
              HeroCreator.pushProfileIntoView(dotHeroName, imageHeroName, docSnapshot.reference, context);
            },
            key: UniqueKey(),
          );
          searchInfoWidgets.add(widget);
        }
        // Handle photographer data
        else if (widget.userType == FirestoreManager.keyIsPhotographer && isPhotographer) {
          createDataForPhotographer(
            circleImageUrl,
            name,
            photographyYears,
            photographyMonths,
            friendliness,
            photographerCost,
            rarity,
            dotHeroName,
            imageHeroName,
            docSnapshot,
            context,
          );
        }
      });
      // done storing all of users information, now we can setState to rebuild
      // and display it
      setState(() {
        searchInfoWidgets.add(SizedBox(height: 90.0));
      });
    });
  }

  createDataForPhotographer(
    String circleImageUrl,
    String name,
    int photographyYears,
    int photographyMonths,
    int friendliness,
    String photographerCost,
    int rarity,
    String dotHeroName,
    String imageHeroName,
    DocumentSnapshot docSnapshot,
    BuildContext context,
  ) {
    String dotHeroName = "";
    String imageHeroName = UniqueKey().toString();

    UserSearchInfo widget = UserSearchInfo(
      backgroundImage: circleImageUrl,
      name: name,
      subtitle: "",
      title: '$photographyYears year(s) and $photographyMonths month(s)',
      friendliness: friendliness,
      cost: photographerCost,
      rarity: rarity,
      onTap: () {
        HeroCreator.pushProfileIntoView(dotHeroName, imageHeroName, docSnapshot.reference, context);
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
