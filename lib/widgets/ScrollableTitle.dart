import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';

class ScrollableTitle extends StatelessWidget {
  final double height;
  final Text title;
  final List<NetworkImage> images;

  ScrollableTitle(
      {this.height = 330.0, @required this.title, @required this.images});

  List<Widget> test1() {
    List<Widget> widgets = List<Widget>();
    widgets.add(SizedBox(width: kCardPadding)); // padding
    for (int i = 0; i < images.length; i++) {
      widgets.add(
        ClickableImageContainer(image: images[i]),
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

class ClickableImageContainer extends StatelessWidget {
  final ImageProvider image;

  ClickableImageContainer({@required this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
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
            image: image),
      ),
    );
  }
}
