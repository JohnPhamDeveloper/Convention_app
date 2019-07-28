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
  final bool enableTopLeftDot;
  final double topLeftDotOuterSize;
  final double topLeftDotInnerSize;
  final Color topLeftDotInnerColor;
  final double topLeftDotLeft;
  final double topLeftDotRight;
  final double topLeftDotTop;
  final double topLeftDotBottom;

  ImageContainer(
      {this.borderRadius = 0.0,
      this.enableTopLeftDot = false,
      this.topLeftDotInnerColor = Colors.green,
      this.topLeftDotInnerSize = 5.0,
      this.topLeftDotOuterSize = 15.0,
      this.heroName = "",
      this.topLeftDotBottom,
      this.topLeftDotLeft,
      this.topLeftDotRight,
      this.topLeftDotTop,
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
    if (enableTopLeftDot) {
      return Positioned(
        left: topLeftDotLeft,
        right: topLeftDotRight,
        top: topLeftDotTop,
        bottom: topLeftDotBottom,
        child: NotificationDot(
          innerColor: topLeftDotInnerColor,
          innerSize: topLeftDotInnerSize,
          outerSize: topLeftDotOuterSize,
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
