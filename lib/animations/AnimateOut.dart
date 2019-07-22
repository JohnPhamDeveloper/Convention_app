import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class AnimateWrapper extends StatelessWidget {
  final double start;
  final Widget myChild;
  final AnimationController controller;
  final AnimationDirection direction;
  final bool shouldAnimateOpacity;
  final bool isOut;

  // CONSTRUCTOR
  AnimateWrapper(
      {this.myChild,
      this.controller,
      this.start,
      this.shouldAnimateOpacity = false,
      this.isOut = false,
      this.direction = AnimationDirection.LEFT});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    // Opacity
    final Animation animationOpacity = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, 1.0, curve: Curves.linear),
      ),
    );

    // Transform
    final Animation animationTransform =
        Tween(begin: 0.0, end: width * -1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(start, 1.0, curve: Curves.easeInOutCubic),
      ),
    );

    return AnimatedBuilder(
      animation: animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: shouldAnimateOpacity ? animationOpacity.value : 1,
          child: Transform(
            transform:
                Matrix4.translationValues(animationTransform.value, 0.0, 0.0),
            child: myChild,
          ),
        );
      },
    );
  }
}
