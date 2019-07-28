import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/IconText.dart';

class HeroProfileStart extends StatelessWidget {
  final String heroName;
  final String imageHeroName;
  final List<dynamic> userImages;
  final List<ImageContainer> userImagesContainer = List<ImageContainer>();
  final String name;
  final int friendliness;
  final int fame;
  final EdgeInsets bottomLeftItemPadding;

  HeroProfileStart(
      {@required this.userImages,
      @required this.name,
      this.imageHeroName = "",
      @required this.friendliness,
      this.heroName = "",
      this.bottomLeftItemPadding =
          const EdgeInsets.only(left: 20.0, bottom: 80.0),
      @required this.fame}) {
    // Add all images to container for the carousel
    // Only give hero name to the first image
    print(imageHeroName);
    userImagesContainer
        .add(createImageContainerWidgetFromURL(userImages[0], imageHeroName));

    for (int i = 1; i < userImagesContainer.length; i++) {
      userImagesContainer
          .add(createImageContainerWidgetFromURL(userImages[i], ''));
    }
  }

  ImageContainer createImageContainerWidgetFromURL(
      String url, String heroName) {
    return ImageContainer(
      heroName: heroName,
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
          loop: false,
          itemCount: userImagesContainer.length,
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
