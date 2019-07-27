import 'package:flutter/material.dart';

class CircularBox extends StatelessWidget {
  final Widget child;
  final double radius;
  final BorderRadiusGeometry borderRadius;
  final double width;
  final double height;
  final Color backgroundColor;
  final EdgeInsets padding;

  CircularBox({
    @required this.child,
    this.radius = 20.0,
    this.borderRadius,
    this.width,
    this.height,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(12.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0, // has the effect of softening the shadow
            spreadRadius: 1.0, // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ],
        color: backgroundColor,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
