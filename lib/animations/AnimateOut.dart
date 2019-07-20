import 'package:flutter/material.dart';

class AnimateOut extends StatelessWidget {
  final double start;
  final Widget myChild;
  final AnimationController controller;

  AnimateOut({this.myChild, this.controller, this.start});

  @override
  Widget build(BuildContext context) {
    // Width
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

    print(animationOpacity.value);
    print(animationTransform.value);

    return AnimatedBuilder(
      animation: animationTransform,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animationOpacity.value,
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
