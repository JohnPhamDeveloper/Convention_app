import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/MyNavbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cosplay_app/widgets/UserSearchInfo.dart';
import 'package:cosplay_app/constants/constants.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  PageController pageController;
  PageView pageView;
  int navIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: navIndex);
    print("Init value $navIndex");
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
          print("Seachpage: $navIndex");
        });
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
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            height: MediaQuery.of(context).size.height -
                kBottomNavHeight -
                80, // 80 is the height of MyNavbar (see the wiget)
            child: pageView),
      ],
    );
  }
}

class CosplayerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
        SizedBox(
            height:
                90.0), // So the last item can be seen and not be scrunched in bottom
      ],
    );
  }
}

class PhotographerSearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserSearchInfo(),
        SizedBox(height: 90.0),
      ],
    );
  }
}
