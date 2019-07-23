import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class ScrollableTitle extends StatelessWidget {
  final double height;
  final Text title;

  ScrollableTitle({this.height = 200.0, @required this.title});

  List<Widget> test1() {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < 12; i++) {
      widgets.add(
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: kRarityBorders[0], width: 3.5),
          ),
          child: Container(
            width: 150,
            child: Center(
              child: Text(
                "BOX",
                style: TextStyle(color: Colors.black),
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
