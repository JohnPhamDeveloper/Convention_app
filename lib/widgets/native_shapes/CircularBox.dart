import 'package:flutter/material.dart';

class CircularBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final BorderRadiusGeometry borderRadius;
  final double width;
  final double height;
  final Color backgroundColor;
  final bool hasShadow;
  final EdgeInsets padding;
  final double maxWidth;

  CircularBox({
    @required this.child,
    this.maxWidth = double.infinity,
    this.radius = 20.0,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor = Colors.white,
    this.hasShadow = true,
    this.padding = const EdgeInsets.all(12.0),
  });

  renderShadow() {
    if (hasShadow) {
      return BoxShadow(
        color: Colors.black12,
        blurRadius: 10.0, // has the effect of softening the shadow
        spreadRadius: 1.0, // has the effect of extending the shadow
        offset: Offset(
          0.0, // horizontal, move right 10
          5.0, // vertical, move down 10
        ),
      );
    }
    return BoxShadow(
      color: Colors.black12,
      blurRadius: 0.0, // has the effect of softening the shadow
      spreadRadius: 0.0, // has the effect of extending the shadow
      offset: Offset(
        0.0, // horizontal, move right 10
        0.0, // vertical, move down 10
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [renderShadow()],
        color: backgroundColor,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
