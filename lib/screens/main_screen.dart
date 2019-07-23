import "package:flutter/material.dart";
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
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
          //Handle button tap
          switch (index) {
            case 0:
              print('Home');
              break;
            case 1:
              print('Notif');
              break;
            case 2:
              print('Fame');
              break;
            case 3:
              print('Profile');
              break;
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, top: 50.0, bottom: 15.0),
          child: ListView(
            children: <Widget>[
              ScrollableTitle(
                title: Text("Most Friendly", style: kCardTitleStyle),
              ),
              SizedBox(height: kCardGap + 10),
              ScrollableTitle(
                title: Text("Highest Fame", style: kCardTitleStyle),
              ),
              SizedBox(height: kCardGap + 10),
              ScrollableTitle(
                title: Text("Most Daily Selfies", style: kCardTitleStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
