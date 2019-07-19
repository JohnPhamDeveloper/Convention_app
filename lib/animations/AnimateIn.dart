import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cosplay_app/constants/constants.dart';

class AnimateIn extends StatefulWidget {
  final Animation animationTransform;
  final Animation animationOpacity;
  final AnimationDirection direction;
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
  double calculateAnimation(double screenWidth, double screenHeight) {
    switch (widget.direction) {
      case AnimationDirection.FROM_LEFT:
        return screenWidth * widget.animationTransform.value * 1;
      case AnimationDirection.FROM_RIGHT:
        return screenWidth * widget.animationTransform.value * -1;
      case AnimationDirection.FROM_TOP:
        return screenHeight * widget.animationTransform.value * 1;
      case AnimationDirection.FROM_BOTTOM:
        return screenHeight * widget.animationTransform.value * -1;
      default:
        return 0.0;
    }
  }

  Widget get(double width, double height) {
    if (widget.direction == AnimationDirection.FROM_LEFT ||
        widget.direction == AnimationDirection.FROM_RIGHT) {
      return Transform(
        transform: Matrix4.translationValues(
            calculateAnimation(width, height), 0.0, 0.0),
        child: widget.child,
      );
    } else {
      return Transform(
        transform: Matrix4.translationValues(
            0.0, calculateAnimation(width, height), 0.0),
        child: widget.child,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: widget.animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: widget.animationOpacity.value,
          child: get(width, height),
        );
      },
    );
  }
}
