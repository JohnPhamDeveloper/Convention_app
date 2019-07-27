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
