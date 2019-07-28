import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';

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
        RankCard(image: images[i]),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Title
        Padding(
          padding: EdgeInsets.only(left: kCardPadding),
          child: title,
        ),
        SizedBox(height: kCardGap),
        // Photo
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

class RankCard extends StatelessWidget {
  final ImageProvider image;

  RankCard({@required this.image});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          // TODO Open user profile
          print('Opening...');
        },
        child: Stack(
          children: <Widget>[
            ImageContainer(
                borderWidth: 3.5,
                borderRadius: 25.0,
                enableShadows: true,
                rarityBorderColor: kRarityBorders[0],
                width: 220,
                image: image),
            Positioned(
              right: 13,
              top: 13,
              child: Container(
                child: NotificationDot(
                  outerSize: 25.0,
                  innerSize: 25.0,
                  innerColor: Colors.pinkAccent,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconText(
                    icon: Icons.face,
                    iconSize: 25.0,
                    text: Text(
                      "Name",
                      style: kProfileOverlayNameStyle,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  IconText(
                    icon: Icons.sentiment_very_satisfied,
                    iconSize: 25.0,
                    text: Text(
                      '2131',
                      style: kProfileOverlayTextStyle,
                    ),
                  ),
//                  SizedBox(height: 5.0),
//                  IconText(
//                    icon: Icons.star,
//                    text: Text(
//                      "1252",
//                      style: kProfileOverlayTextStyle,
//                    ),
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle = TextStyle(
    fontSize: 17.0,
    color: Colors.white,
    fontWeight: FontWeight.w700,
    shadows: kTextStrokeOutlines);

final Color kTextStrokeColor = Colors.black54;
final double kTextStrokeBlur = 5.0;
final List<Shadow> kTextStrokeOutlines = [
  Shadow(
// bottomLeft
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// bottomRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// topRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, 1.5),
      color: kTextStrokeColor),
  Shadow(
// topLeftblur
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, 1.5),
      color: kTextStrokeColor),
];

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Text text;

  IconText(
      {@required this.icon,
      this.iconSize = 30.0,
      @required this.text,
      this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              left: 0.2,
              top: 0.2,
              child: Icon(icon, color: Colors.black12, size: iconSize + 2.0),
            ),
            Icon(icon, color: iconColor, size: iconSize),
          ],
        ),
        SizedBox(width: 10.0),
        text
      ],
    );
  }
}
