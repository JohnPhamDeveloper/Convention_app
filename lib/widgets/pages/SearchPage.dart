import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/MyNavbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  PageController pageController;
  PageView pageView;
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
    pageView = PageView(
      onPageChanged: (index) {
//        setState(() {
//          navIndex = index;
//        });
      },
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        CosplayerSearchSection(),
        PhotographerSearchSection(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyNavbar(
          context: context,
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
        SizedBox(height: 25.0),
        Container(
            width: 500,
            height: MediaQuery.of(context).size.height - 200,
            child: pageView),
      ],
    );
  }
}

class CosplayerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: MediaQuery.of(context).size.height - 200,
      child: ListView(
        children: <Widget>[
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
          UserSearchInfo(),
        ],
      ),
    );
  }
}

class PhotographerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: MediaQuery.of(context).size.height - 200,
      child: ListView(
        children: <Widget>[
          UserSearchInfo(),
        ],
      ),
    );
  }
}
