import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/TopNavBarWithLines.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/HeroCreator.dart';
import 'package:cosplay_app/widgets/FireMap.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  PageController pageController;
  PageView pageView;
  int navIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      controller: pageController,
      children: <Widget>[
        SearchSectionItem(userType: FirestoreManager.keyIsCosplayer),
        SearchSectionItem(userType: FirestoreManager.keyIsPhotographer),
        // PhotographerSearchSection(),
      ],
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: FireMap(),
        ),
        Flexible(
          flex: 3,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  TopNavBarWithLines(
                    context: context,
                    index: navIndex,
                    onCosplayersTap: () {
                      pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    onPhotographersTap: () {
                      pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  Expanded(child: pageView),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, bottom: 100.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: RoundButton(
                    icon: FontAwesomeIcons.cog,
                    iconColor: Colors.white,
                    fillColor: Colors.pinkAccent,
                    onTap: () {},
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// SEARCH SECTION ITEM ----------------- BREAK INTO NEW FILE
//
//
//
//
//
//
//
//
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
    return ListView.builder(
      itemCount: searchInfoWidgets.length,
      itemBuilder: (context, index) {
        return searchInfoWidgets[index];
      },
    );
  }
}

//class PhotographerSearchSection extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemCount: photo
//      itemBuilder: (context, index) {
//        return cosplayerSearchInfoWidgets[index];
//      },
//    );
////    return ListView(
////      children: <Widget>[
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 12,
//////          monthsExperience: 2,
//////          backgroundImage:
//////              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d",
//////          friendliness: 324,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Resano Bobs",
//////          yearsExperience: 1,
//////          monthsExperience: 2,
//////          cost: "Can Negotiate",
//////          backgroundImage:
//////              "https://c.pxhere.com/images/c7/21/c8e22db330eb09e78970ac8b2ce2-1456325.jpg!d",
//////          friendliness: 153,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 2,
//////          monthsExperience: 3,
//////          cost: "\$52.12 / hr",
//////          backgroundImage:
//////              "https://c.pxhere.com/images/52/27/c8e31718a7e13b915f72689e7911-1424101.jpg!d",
//////          friendliness: 45,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Bob Smith",
//////          yearsExperience: 4,
//////          monthsExperience: 6,
//////          cost: "\$92.12 / session",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/9d/fd/photographer_camera_photo_photos_foto_lens_take_a_photograph_electronic_equipment-942701.jpg!d",
//////          friendliness: 32,
//////        ),
//////        PhotographerSearchInfo(
//////          name: ""
//////              "Nunjo Saert",
//////          yearsExperience: 8,
//////          monthsExperience: 1,
//////          cost: "Not Shooting",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/b3/2d/camera_digital_equipment_female_girl_isolated_lens_people-1260617.jpg!d",
//////          friendliness: 74,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Teer San",
//////          yearsExperience: 3,
//////          monthsExperience: 3,
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/08/97/photographer_road_camera_girl_person-180399.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Loon Poi",
//////          yearsExperience: 8,
//////          monthsExperience: 4,
//////          cost: "\$15.00 / hr",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/62/c1/camera_photographer_person_photography_urban-133163.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Erri Wan",
//////          yearsExperience: 1,
//////          monthsExperience: 3,
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/64/b4/photographer_photography_digital_camera_dslr_camera_digital_single_lens_reflex_camera_camera-964918.jpg!d",
//////          friendliness: 99,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 12,
//////          monthsExperience: 2,
//////          backgroundImage:
//////              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        SizedBox(height: 90.0),
////      ],
////    );
//  }
//}
