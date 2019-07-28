import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';

class HeroProfileStart extends StatelessWidget {
  final String heroName;
  final List<dynamic> userImages;
  final List<ImageContainer> userImagesContainer = List<ImageContainer>();
  final String name;
  final int friendliness;
  final int fame;
  final EdgeInsets bottomLeftItemPadding;

  HeroProfileStart(
      {@required this.userImages,
      @required this.name,
      @required this.friendliness,
      this.heroName = "",
      this.bottomLeftItemPadding =
          const EdgeInsets.only(left: 20.0, bottom: 80.0),
      @required this.fame}) {
    for (String url in userImages) {
      userImagesContainer.add(createImageContainerWidgetFromURL(url));
    }
  }

  ImageContainer createImageContainerWidgetFromURL(String url) {
    return ImageContainer(
      image: url,
      height: double.infinity,
      width: double.infinity,
    );
  }

  Widget dotHeroRender() {
    if (heroName.isNotEmpty) {
      return Hero(
        tag: heroName,
        child: NotificationDot(innerColor: Colors.pinkAccent),
      );
    }

    return NotificationDot(innerColor: Colors.pinkAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Carousel
        Swiper(
          itemBuilder: (BuildContext context, int index) {
            return userImagesContainer[index];
          },
          itemCount: userImages.length,
          pagination: SwiperPagination(
              alignment: Alignment.topCenter, builder: SwiperPagination.dots),
          control: SwiperControl(
            color: Colors.white,
          ),
        ),
        // User information bottom left
        Padding(
          padding: bottomLeftItemPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconText(
                icon: Icons.face,
                text: Text(
                  name,
                  style: kProfileOverlayNameStyle,
                ),
              ),
              SizedBox(height: 10.0),
              IconText(
                icon: Icons.sentiment_very_satisfied,
                text: Text(
                  friendliness.toString(),
                  style: kProfileOverlayTextStyle,
                ),
              ),
              SizedBox(height: 10.0),
              IconText(
                icon: Icons.star,
                text: Text(
                  fame.toString(),
                  style: kProfileOverlayTextStyle,
                ),
              ),
            ],
          ),
        ),
        // Dot
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: dotHeroRender(),
          ),
        ),
      ],
    );
  }
}

final Color kTextStrokeColor = Colors.black26;
final double kTextStrokeBlur = 1.0;
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

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 30.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle = TextStyle(
    fontSize: 25.0,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    shadows: kTextStrokeOutlines);

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
