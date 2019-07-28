import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ScrollableTitle extends StatelessWidget {
  final double height;
  final Text title;
  //final List<NetworkImage> images;
  final List<Widget> child;

  ScrollableTitle(
      {this.height = 330.0,
      @required this.title,
      //required this.images,
      @required this.child});

//  List<Widget> test1() {
//    List<Widget> widgets = List<Widget>();
//    widgets.add(SizedBox(width: kCardPadding)); // padding
//    for (int i = 0; i < images.length; i++) {
//      widgets.add(
//        RankCard(image: images[i]),
//      );
//    }
//    return widgets;
//  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Title
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: kCardPadding),
              child: title,
            ),
            SizedBox(width: 10.0),
            Icon(
              FontAwesomeIcons.questionCircle,
              color: Colors.white,
            )
          ],
        ),
        SizedBox(height: kCardGap),
        // Photo
        Container(
          height: height,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: child.length,
              itemBuilder: (context, index) {
                return child[index];
              }),
        ),
      ],
    );
  }
}
