import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';

class ScrollableTitle extends StatelessWidget {
  final double height;
  final Text title;

  ScrollableTitle({this.height = 330.0, @required this.title});

  List<Widget> test1() {
    List<Widget> widgets = List<Widget>();
    widgets.add(SizedBox(width: kCardPadding)); // padding
    for (int i = 0; i < 12; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {
              // TODO Open user profile
              print('Opening...');
            },
            child: ImageContainer(
                borderWidth: 3.5,
                borderRadius: 25.0,
                enableShadows: true,
                rarityBorderColor: kRarityBorders[0],
                width: 220,
                image: NetworkImage(
                    "https://c.pxhere.com/photos/eb/33/china_girls_game_anime_cute_girl_japanese_costume-187564.jpg!d")),
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
