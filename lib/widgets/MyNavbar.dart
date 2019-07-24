import 'package:flutter/material.dart';

class MyNavbar extends StatefulWidget {
  final BuildContext context;

  MyNavbar({@required this.context});

  @override
  _MyNavbarState createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  TextStyle style = TextStyle(fontWeight: FontWeight.w400, fontSize: 22.0);
  double navBarHeight = 80.0;
  double gap = 10.0;
  double lineWidth = 100.0;
  double lineThickness = 1.5;
  double linePositionX = 250.0;
  int index = 0;
  int numberOfNavButtons = 2;

  @override
  void initState() {
    super.initState();
    // First nav item is active
    index = 0;
    linePositionX = calculateNextLinePosition(widget.context);
  }

  Widget createNavButton(String title, Function onTap) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Text(
                title,
                style: style,
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  double calculateNextLinePosition(BuildContext context) {
    // Get the width of nav items
    double calculateWidthOfEachNavButton() {
      return (MediaQuery.of(context).size.width / numberOfNavButtons);
    }

    // Get the center of the nav items
    double calculateCenterOfEachNavButton() {
      return calculateWidthOfEachNavButton() / 2;
    }

    // Return the next position of the line
    return calculateCenterOfEachNavButton() +
        (index * calculateWidthOfEachNavButton());
  }

  @override
  Widget build(BuildContext context) {
    // Starts on first nav item

    return Container(
      height: navBarHeight,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createNavButton("Cosplayers", () {
                print("Cosplayers");
                setState(() {
                  index = 0;
                  linePositionX = calculateNextLinePosition(context);
                });
              }),
              createNavButton("Photographer", () {
                print("Photographers");
                setState(() {
                  index = 1;
                  linePositionX = calculateNextLinePosition(context);
                });
              })
            ],
          ),
          Transform(
            transform: Matrix4.translationValues(
                calculateNextLinePosition(context) -
                    (lineWidth / numberOfNavButtons),
                0.0,
                0.0),
            child: Container(
              width: lineWidth,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: lineThickness, color: Colors.pink),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
