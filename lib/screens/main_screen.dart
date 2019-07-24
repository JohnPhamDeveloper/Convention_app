import "package:flutter/material.dart";
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cosplay_app/widgets/pages/RankingListPage.dart';
import 'package:cosplay_app/widgets/pages/SearchPage.dart';
import 'package:cosplay_app/widgets/pages/FamePage.dart';
import 'package:cosplay_app/widgets/pages/NotificationPage.dart';
import 'package:cosplay_app/widgets/pages/ProfilePage.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cosplay_app/constants/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController;
  CircularBottomNavigationController _navigationController;
  int navIndex = 0;
  PageView pageView;
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.pink),
    TabItem(Icons.search, "Search", Colors.pink),
    TabItem(Icons.business_center, "Rewards", Colors.pink),
    TabItem(Icons.notifications, "Notifications", Colors.pink),
    TabItem(Icons.person, "Profile", Colors.pink),
  ]);

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
    _navigationController = CircularBottomNavigationController(navIndex);
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          print(index);
          navIndex = index;
        });
      },
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        RankingListPage(),
        SearchPage(),
        FamePage(),
        NotificationPage(),
        ProfilePage(),
      ],
    );
  }

  void moveToSelectedPage(int index) {
    setState(() {
      navIndex = index;
    });
    pageController.animateToPage(
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
                print("selected $selectedPos");
                moveToSelectedPage(selectedPos);
              },
            ),
          )
        ]),
      ),
    );
  }
}
