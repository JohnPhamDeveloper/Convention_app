import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cosplay_app/constants/constants.dart';

class AnimationWrapper extends StatefulWidget {
  final AnimationController controller;
  final AnimationDirection direction;
  final double start;
  final Widget child;
  final bool shouldAnimateOpacity;
  final bool isOut; // Should be animating OUT of screen?

  AnimationWrapper(
      {@required this.controller,
      this.isOut = false,
      this.start = 0.0,
      this.shouldAnimateOpacity = false,
      this.direction = AnimationDirection.LEFT,
      @required this.child});

  @override
  _AnimationWrapperState createState() => _AnimationWrapperState();
}

class _AnimationWrapperState extends State<AnimationWrapper> {
  Animation animationOpacity;
  Animation animationTransform;

  @override
  void initState() {
    super.initState();
    animationTransform =
        createTransformAnimationAtStart(widget.start, Curves.easeInOutCubic);
    animationOpacity =
        createOpacityAnimationAtStart(widget.start, Curves.linearToEaseOut);
  }

  // Animate depending on what direction was chosen by the user
  double calculateAnimation(
      double screenWidth, double screenHeight, Animation animationTransform) {
    switch (widget.direction) {
      case AnimationDirection.LEFT:
        return screenWidth * animationTransform.value * -1;
      case AnimationDirection.RIGHT:
        return screenWidth * animationTransform.value * 1;
      case AnimationDirection.TOP:
        return screenHeight * animationTransform.value * -1;
      case AnimationDirection.BOTTOM:
        return screenHeight * animationTransform.value * 1;
      default:
        return 0.0;
    }
  }

  // Determines which axis the animation happens on
  Widget animatedChild(
      double width, double height, Animation animationTransform) {
    if (widget.direction == AnimationDirection.LEFT ||
        widget.direction == AnimationDirection.RIGHT) {
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

  // Creates animation depending on whether it's animating OUT OF SCREEN or IN OF SCREEN
  Animation createTransformAnimationAtStart(double start, Curve curve) {
    // Animating out of the screen
    if (widget.isOut) {
      return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.controller,
        curve: Interval(start, 1.0, curve: curve),
      ));
    }
    // Animating into the screen
    else {
      return Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: widget.controller,
        curve: Interval(start, 1.0, curve: curve),
      ));
    }
  }

  // Opacity might be expensive to animate?
  Animation createOpacityAnimationAtStart(double start, Curve curve) {
    return Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: widget.controller,
      curve: Interval(start, 1.0, curve: curve),
    ));
  }

  @override
  void didUpdateWidget(AnimationWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOut != widget.isOut) {
      animationTransform =
          createTransformAnimationAtStart(widget.start, Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: widget.shouldAnimateOpacity ? animationOpacity.value : 1.0,
          child: animatedChild(width, height, animationTransform),
        );
      },
    );
  }
}
