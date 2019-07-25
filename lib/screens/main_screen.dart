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

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PreloadPageController preloadPageController;
  CircularBottomNavigationController _navigationController;
  bool playProfilePageCarousel = false;
  int navIndex = 0;
  PreloadPageView pageView;
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.deepPurpleAccent),
    TabItem(Icons.search, "Search", Colors.green),
    TabItem(Icons.business_center, "Rewards", Colors.deepOrangeAccent),
    TabItem(Icons.notifications, "Alerts", Colors.redAccent),
    TabItem(Icons.person, "Profile", Colors.pinkAccent),
  ]);

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
