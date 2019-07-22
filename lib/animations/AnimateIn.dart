import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cosplay_app/constants/constants.dart';

class AnimateIn extends StatefulWidget {
  final AnimationController controller;
  final AnimationDirection direction;
  final double start;
  final Widget child;

  AnimateIn(
      {@required this.controller,
      this.start = 0.0,
      this.direction = AnimationDirection.FROM_LEFT,
      @required this.child});

  @override
  _AnimateInState createState() => _AnimateInState();
}

class _AnimateInState extends State<AnimateIn> {
  double calculateAnimation(
      double screenWidth, double screenHeight, Animation animationTransform) {
    switch (widget.direction) {
      case AnimationDirection.FROM_LEFT:
        return screenWidth * animationTransform.value * 1;
      case AnimationDirection.FROM_RIGHT:
        return screenWidth * animationTransform.value * -1;
      case AnimationDirection.FROM_TOP:
        return screenHeight * animationTransform.value * 1;
      case AnimationDirection.FROM_BOTTOM:
        return screenHeight * animationTransform.value * -1;
      default:
        return 0.0;
    }
  }

  Widget animatedChild(
      double width, double height, Animation animationTransform) {
    if (widget.direction == AnimationDirection.FROM_LEFT ||
        widget.direction == AnimationDirection.FROM_RIGHT) {
      return Transform(
        transform: Matrix4.translationValues(
            calculateAnimation(width, height, animationTransform), 0.0, 0.0),
        child: widget.child,
      );
    } else {
      return Transform(
        transform: Matrix4.translationValues(
            0.0, calculateAnimation(width, height, animationTransform), 0.0),
        child: widget.child,
      );
    }
  }

  Animation createTransformAnimationAtStart(double start, Curve curve) {
    return Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, 1.0, curve: curve),
    ));
  }

  Animation createOpacityAnimationAtStart(double start, Curve curve) {
    return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, 1.0, curve: curve),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    Animation animationOpacity =
        createOpacityAnimationAtStart(widget.start, Curves.linearToEaseOut);

    Animation animationTransform =
        createTransformAnimationAtStart(widget.start, Curves.easeInOutCubic);

    return AnimatedBuilder(
      animation: animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animationOpacity.value,
          child: animatedChild(width, height, animationTransform),
        );
      },
    );
  }
}
