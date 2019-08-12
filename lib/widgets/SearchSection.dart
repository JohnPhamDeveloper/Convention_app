import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ChipNavigator.dart';
import 'package:cosplay_app/widgets/SearchSectionItem.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  @override
  _SearchSectionState createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  LoggedInUser loggedInUser;
  PageController pageController;
  PageView pageView;
  int navIndex = 0;
  List<Map<dynamic, dynamic>> cosplayersNearby = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> photographersNearby = List<Map<dynamic, dynamic>>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: navIndex);
  }

  _updateNearbyUsers() {
    cosplayersNearby.clear();
    photographersNearby.clear();
    for (int i = 0; i < loggedInUser.getUsersNearby.length; i++) {
      if (loggedInUser.getUsersNearby[i]['isCosplayer'])
        setState(() {
          cosplayersNearby.add(loggedInUser.getUsersNearby[i]);
        });
      else if (loggedInUser.getUsersNearby[i]['isPhotographer'])
        setState(() {
          photographersNearby.add(loggedInUser.getUsersNearby[i]);
        });

      //TODO need congoer section
    }
  }

  _refreshPages() {
    setState(() {
      pageView = PageView(
        key: UniqueKey(),
        onPageChanged: (index) {
          setState(() {
            navIndex = index;
          });
        },
        controller: pageController,
        children: <Widget>[
          SearchSectionItem(
            usersNearby: cosplayersNearby,
            firebaseUser: loggedInUser.getFirebaseUser,
            loggedInUserLatLng: loggedInUser.getPosition,
          ),
          SearchSectionItem(
            usersNearby: photographersNearby,
            firebaseUser: loggedInUser.getFirebaseUser,
            loggedInUserLatLng: loggedInUser.getPosition,
          ),
          //TODO congoer section
        ],
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("SEARCH SECTION @*(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((9");
    loggedInUser = Provider.of<LoggedInUser>(context);
    print(loggedInUser.getUsersNearby);
    _updateNearbyUsers();
    _refreshPages();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            ChipNavigator(
              key: Key("searchSectionChipNavigator"),
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
            SizedBox(height: 6.0),
            Expanded(key: Key('searchSectionPageView'), child: pageView)
          ],
        ),
      ],
    );
  }
}
