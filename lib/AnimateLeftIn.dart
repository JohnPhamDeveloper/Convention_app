import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class AnimateLeftIn extends StatefulWidget {
  final Animation animationTransform;
  final Animation animationOpacity;
  final AnimationController animationController;
  final int direction;
  final Widget child;

  AnimateLeftIn(
      {@required this.animationTransform,
      @required this.animationOpacity,
      @required this.animationController,
      @required this.direction,
      @required this.child});

  @override
  _AnimateLeftInState createState() => _AnimateLeftInState();
}

class _AnimateLeftInState extends State<AnimateLeftIn> {
  @override
  void initState() {
    super.initState();
    widget.animationController.forward();
  }

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
