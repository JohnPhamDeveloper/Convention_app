import 'package:flutter/material.dart';

class CircularBoxClipped extends StatelessWidget {
  final Widget child;
  final double radius;
  final Radius topLeft;
  final Radius topRight;
  final Radius bottomLeft;
  final Radius bottomRight;

  CircularBoxClipped(
      {@required this.child,
      this.radius = 20.0,
      this.topLeft = Radius.zero,
      this.topRight = Radius.zero,
      this.bottomLeft = Radius.zero,
      this.bottomRight = Radius.zero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: topLeft,
            topRight: topRight,
            bottomLeft: bottomLeft,
            bottomRight: bottomRight),
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
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
