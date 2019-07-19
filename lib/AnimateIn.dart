import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cosplay_app/constants/constants.dart';

class AnimateIn extends StatefulWidget {
  final Animation animationTransform;
  final Animation animationOpacity;
  final int direction;
  final Widget child;

  AnimateIn(
      {@required this.animationTransform,
      @required this.animationOpacity,
      this.direction = AnimationDirection.FROM_LEFT,
      @required this.child});

  @override
  _AnimateInState createState() => _AnimateInState();
}

class _AnimateInState extends State<AnimateIn> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: widget.animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: widget.animationOpacity.value,
          child: Transform(
            transform: Matrix4.translationValues(
                width * widget.animationTransform.value * widget.direction,
                0.0,
                0.0),
            child: widget.child,
          ),
        );
      },
    );
  }
}
