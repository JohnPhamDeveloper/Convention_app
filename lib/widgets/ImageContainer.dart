import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';

class ImageContainer extends StatelessWidget {
  final String heroName;
  final String image;
  final double borderRadius;
  final double borderWidth;
  final Color rarityBorderColor;
  final double height;
  final double width;
  final bool enableShadows;
  final bool enableStatusDot;
  final double statusDotOuterSize;
  final double statusDotInnerSize;
  final Color statusDotInnerColor;
  final double statusDotLeft;
  final double statusDotRight;
  final double statusDotTop;
  final double statusDotBottom;
  final bool enableSelfieDot;
  final double selfieDotOuterSize;
  final double selfieDotInnerSize;
  final Color selfieDotInnerColor;
  final double selfieDotLeft;
  final double selfieDotRight;
  final double selfieDotTop;
  final double selfieDotBottom;

  ImageContainer(
      {this.borderRadius = 0.0,
      this.enableStatusDot = false,
      this.statusDotInnerColor = Colors.green,
      this.statusDotInnerSize = 5.0,
      this.statusDotOuterSize = 15.0,
      this.heroName = "",
      this.statusDotBottom,
      this.statusDotLeft,
      this.statusDotRight,
      this.statusDotTop,
      this.selfieDotBottom,
      this.selfieDotInnerColor = Colors.pinkAccent,
      this.selfieDotInnerSize = 5.0,
      this.selfieDotLeft,
      this.selfieDotOuterSize = 15.0,
      this.selfieDotRight,
      this.selfieDotTop,
      this.enableSelfieDot = false,
      this.width = 300,
      this.height = 300,
      this.enableShadows = true,
      this.borderWidth = 0,
      this.rarityBorderColor = Colors.white,
      @required this.image});

  BoxShadow renderShadow() {
    if (enableShadows)
      return BoxShadow(
        color: Colors.black12,
        blurRadius: 5.0, // has the effect of softening the shadow
        spreadRadius: 1.0, // has the effect of extending the shadow
        offset: Offset(
          1.0, // horizontal, move right 10
          5.0, // vertical, move down 10
        ),
      );
    return BoxShadow(
      color: Colors.cyan[300],
      blurRadius: 0.0, // has the effect of softening the shadow
      spreadRadius: 0.0, // has the effect of extending the shadow
      offset: Offset(
        0.0, // horizontal, move right 10
        10.0, // vertical, move down 10
      ),
    );
  }

  Widget renderStatusDot() {
    if (enableStatusDot) {
      return Positioned(
        left: statusDotLeft,
        right: statusDotRight,
        top: statusDotTop,
        bottom: statusDotBottom,
        child: NotificationDot(
          innerColor: statusDotInnerColor,
          innerSize: statusDotInnerSize,
          outerSize: statusDotOuterSize,
        ),
      );
    }

    return Container(width: 0, height: 0);
  }

  Widget renderSelfieDot() {
    if (enableSelfieDot) {
      return Positioned(
        left: selfieDotLeft,
        right: selfieDotRight,
        top: selfieDotTop,
        bottom: selfieDotBottom,
        child: NotificationDot(
          innerColor: selfieDotInnerColor,
          innerSize: selfieDotInnerSize,
          outerSize: selfieDotOuterSize,
        ),
      );
    }

    return Container(width: 0, height: 0);
  }

  Widget heroWidget() {
    if (heroName.isEmpty) {
      return Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(
              border: Border.all(width: borderWidth, color: rarityBorderColor),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: FadeInImage.memoryNetwork(
                width: width,
                height: height,
                fadeInDuration: Duration(seconds: 1),
                fadeInCurve: Curves.easeInOut,
                fit: BoxFit.cover,
                placeholder: kTransparentImage,
                image: image,
              ),
            ),
          ),
          renderStatusDot(),
          renderSelfieDot(),
        ],
      );
    } else {
      return Hero(
        tag: heroName,
        child: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: BoxDecoration(
                border:
                    Border.all(width: borderWidth, color: rarityBorderColor),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: FadeInImage.memoryNetwork(
                  width: width,
                  height: height,
                  fadeInDuration: Duration(seconds: 1),
                  fadeInCurve: Curves.easeInOut,
                  fit: BoxFit.cover,
                  placeholder: kTransparentImage,
                  image: image,
                ),
              ),
            ),
            renderStatusDot(),
            renderSelfieDot(),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return heroWidget();
  }
}
