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
        Container(
          width: 200,
          color: color,
          child: Center(child: title),
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
            padding: const EdgeInsets.all(8.0),
            children: test1(color),
          ),
        ),
      ],
    );
  }
}
