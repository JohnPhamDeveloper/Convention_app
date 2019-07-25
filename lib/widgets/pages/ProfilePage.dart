import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/pages/ProfileStartPage.dart';
import 'package:cosplay_app/widgets/pages/ProfileDetailsPage.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  PageController pageController;
  PageView pageView;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    pageView = PageView(
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
//        setState(() {
//          navIndex = index;
//        });
      },
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      children: <Widget>[
        ProfileStartPage(),
        ProfileDetailsPage(),
      ],
    );
  }

  void moveToDetailsPage() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        pageView,
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 140.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RoundButton(
                icon: Icons.arrow_downward,
                iconColor: Colors.white,
                fillColor: Colors.pinkAccent,
                onTap: () {
                  setState(() {
                    moveToDetailsPage();
                  });
                }),
          ),
        ),
      ],
    );
  }
}
