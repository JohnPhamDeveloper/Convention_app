import "package:flutter/material.dart";
import 'package:cosplay_app/widgets/pages/RankingListPage.dart';
import 'package:cosplay_app/widgets/pages/SearchPage.dart';
import 'package:cosplay_app/widgets/pages/FamePage.dart';
import 'package:cosplay_app/widgets/pages/NotificationPage.dart';
import 'package:cosplay_app/widgets/pages/ProfilePage.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/widgets/LoadingIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LoggedInUser loggedInUser;
  bool loadedUserData = false;
  PreloadPageController preloadPageController;
  CircularBottomNavigationController _navigationController;
  bool playProfilePageCarousel = false;
  int navIndex = 0;
  PreloadPageView pageView;
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.pinkAccent),
    TabItem(Icons.search, "Search", Colors.pinkAccent),
    TabItem(Icons.business_center, "Rewards", Colors.pinkAccent),
    TabItem(Icons.notifications, "Alerts", Colors.pinkAccent),
    TabItem(Icons.person, "Profile", Colors.pinkAccent),
  ]);

  @override
  void initState() {
    super.initState();
    loggedInUser = LoggedInUser();
    preloadPageController = PreloadPageController(initialPage: navIndex);
    _navigationController = CircularBottomNavigationController(navIndex);
    pageView = PreloadPageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      preloadPagesCount: 5,
      physics: new NeverScrollableScrollPhysics(),
      controller: preloadPageController,
      children: <Widget>[
        RankingListPage(),
        SearchPage(),
        FamePage(),
        NotificationPage(),
        ProfilePage(),
      ],
    );

    // Get data from database for logged in user when it changes
    // Set loading is called if data is successfuly updated into loggedInUser
    FirestoreManager.streamUserData(loggedInUser, setLoading);

    createMockUser();
  }

  // TODO DELEETE THIS MOCK USER
  void createMockUser() async {
    List<String> photoUrls = [
      "https://c.pxhere.com/photos/bb/92/boy_portrait_people_man_anime_face_35mm_comic-185893.jpg!d"
    ];
    List<String> urls = [
      "https://c.pxhere.com/photos/fb/84/50mm_anime_comic_comiccon_cosplay_costume_cute_face-343295.jpg!d"
    ];
    await FirestoreManager.createUserInDatabase(
      documentName: "testUser2",
      fame: 45,
      friendliness: 512,
      displayName: "Netarno",
      photoUrls: photoUrls,
      cosplayName: "Netarno",
      seriesName: "Naruto",
      isCosplayer: true,
      isPhotographer: true,
      rarityBorder: 3,
      realName: "Bobby Jones",
      cosplayerCost: "\$52.00/hr",
      photographerCost: "\$42.00/hr",
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser3",
      fame: 66,
      friendliness: 512,
      displayName: "Renaldo",
      cosplayName: "Gaia",
      seriesName: "Finals Fantasy",
      photoUrls: urls,
      isCosplayer: true,
      isPhotographer: true,
      rarityBorder: 2,
      realName: "Bobby Jones",
      cosplayerCost: "\$12.00/hr",
      photographerCost: '\$42.00/hr',
    );
//    await Firestore.instance.collection("users").document("testUser2").setData({
//      FirestoreManager.keyFame: 45,
//      FirestoreManager.keyFriendliness: 512,
//      FirestoreManager.keyDisplayName: "Netarno",
//      FirestoreManager.keyPhotos: [
//        "https://c.pxhere.com/photos/bb/92/boy_portrait_people_man_anime_face_35mm_comic-185893.jpg!d"
//      ],
//      FirestoreManager.keyIsCosplayer: true,
//      FirestoreManager.keyIsPhotographer: true,
//      FirestoreManager.keyRarityBorder: 0,
//      FirestoreManager.keyRealName: "Bobby Jones",
//      FirestoreManager.keyDateRegistered: DateTime.now(),
//    }, merge: true);
    print("Finished creating mock user");
  }

  void setLoading() {
    print("how many times is this called?");
    loggedInUser.updateWidgetsListeningToThis();
    setState(() {
      loadedUserData = true; // Stop showing spinner
    });
  }

  @override
  void dispose() {
    _navigationController.dispose();
    preloadPageController.dispose();
    super.dispose();
  }

  void moveToSelectedPage(int index) {
    setState(() {
      navIndex = index;
    });
    preloadPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget renderLoadingIfNotLoaded() {
    if (loadedUserData) {
      return ChangeNotifierProvider<LoggedInUser>(
        builder: (context) => loggedInUser,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Stack(children: <Widget>[
              pageView,
              Align(
                alignment: Alignment.bottomCenter,
                child: CircularBottomNavigation(
                  tabItems,
                  barHeight: kBottomNavHeight,
                  controller: _navigationController,
                  selectedCallback: (int selectedPos) {
                    moveToSelectedPage(selectedPos);
                  },
                ),
              )
            ]),
          ),
        ),
      );
    }
    return LoadingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return renderLoadingIfNotLoaded();
  }
}
