import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

/*
* The controller for the Hero details and Hero start page when you click
* on a person in ranked page or search page
* Note: This is different from the User profile page
 */
class HeroProfilePage extends StatefulWidget {
  final List<Widget> pages;

  HeroProfilePage({@required this.pages});
  @override
  _HeroProfilePageState createState() => _HeroProfilePageState();
}

class _HeroProfilePageState extends State<HeroProfilePage>
    with SingleTickerProviderStateMixin {
  PreloadPageController pageController;
  PreloadPageView pageView;
  AnimationController animationControllerArrow;
  Animation animationArrow;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PreloadPageController(initialPage: 0);
    pageView = PreloadPageView(
      scrollDirection: Axis.vertical,
      onPageChanged: (index) {
        setState(() {
          _navIndex = index;
        });
      },
      preloadPagesCount: 2,
      physics: new NeverScrollableScrollPhysics(),
      controller: pageController,
      children: widget.pages,
    );

    animationControllerArrow =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
  }

  void moveToDetailsPage() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void moveToFirstPage() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    animationControllerArrow.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Stack(
      children: <Widget>[
        pageView,
        Padding(
          padding: const EdgeInsets.only(right: 20.0, bottom: 70.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 0.5).animate(
                CurvedAnimation(
                    parent: animationControllerArrow, curve: Curves.easeInOut),
              ),
              child: RoundButton(
                icon: Icons.arrow_downward,
                iconColor: Colors.white,
                fillColor: Colors.pinkAccent,
                onTap: () {
                  if (_navIndex == 0) {
                    animationControllerArrow.forward();
                    moveToDetailsPage();
                  } else {
                    animationControllerArrow.reverse();
                    moveToFirstPage();
                  }
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, left: 15.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: RoundButton(
              size: 40,
              padding: EdgeInsets.all(0),
              icon: Icons.arrow_back,
              iconSize: 25.0,
              iconColor: Colors.white,
              fillColor: Colors.pinkAccent,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}
