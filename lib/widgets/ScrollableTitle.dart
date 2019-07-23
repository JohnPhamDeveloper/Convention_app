import 'package:flutter/material.dart';

class ScrollableTitle extends StatelessWidget {
  final Color color;
  final double height;
  final Text title;

  ScrollableTitle({this.color, @required this.height, @required this.title});

  List<Widget> test1(Color color) {
    List<Widget> widgets = List<Widget>();
    for (int i = 0; i < 12; i++) {
      widgets.add(
        Card(
          elevation: 2.5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: BorderSide(color: Colors.blueAccent, width: 3.0)),
          child: Container(
            width: 250,
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
      children: <Widget>[
        title,
        Container(
          height: height,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: test1(color),
          ),
        ),
      ],
    );
  }
}
