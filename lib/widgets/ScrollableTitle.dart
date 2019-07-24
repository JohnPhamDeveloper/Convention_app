import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class ScrollableTitle extends StatelessWidget {
  final double height;
  final Text title;

  ScrollableTitle({this.height = 330.0, @required this.title});

  List<Widget> test1() {
    List<Widget> widgets = List<Widget>();
    widgets.add(SizedBox(width: kCardPadding)); // padding
    for (int i = 0; i < 12; i++) {
      widgets.add(
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: kRarityBorders[0], width: 3.5),
          ),
          child: InkWell(
            onTap: () {
              // TODO Open user profile
              print('Opening...');
            },
            child: Container(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Cosplayer",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: kCardPadding),
          child: title,
        ),
        SizedBox(height: kCardGap),
        Container(
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: test1(),
          ),
        ),
      ],
    );
  }
}
