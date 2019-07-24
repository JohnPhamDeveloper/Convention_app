import "package:flutter/material.dart";
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cosplay_app/widgets/pages/RankingListPage.dart';
import 'package:cosplay_app/widgets/pages/SearchPage.dart';
import 'package:cosplay_app/widgets/pages/FamePage.dart';
import 'package:cosplay_app/widgets/pages/NotificationPage.dart';
import 'package:cosplay_app/widgets/pages/ProfilePage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController pageController;
  int navIndex = 0;
  PageView pageView;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: CurvedNavigationBar(
        index: navIndex,
        height: 60.0,
        backgroundColor: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.pink,
        color: Colors.pink,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.business_center, size: 30, color: Colors.white),
          Icon(Icons.notifications, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
          pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: SafeArea(
        child: pageView,
      ),
    );
  }
}
