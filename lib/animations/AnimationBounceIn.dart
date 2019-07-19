import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimationBounceIn extends StatelessWidget {
  final int durationSeconds;
  final int durationMilliseconds;
  final int delaySeconds;
  final int delayMilliseconds;
  final Widget child;

  AnimationBounceIn(
      {this.durationMilliseconds = 500,
      this.durationSeconds = 0,
      this.delaySeconds = 0,
      this.delayMilliseconds = 0,
      @required this.child});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("Scale").add(
          Duration(
              seconds: durationSeconds, milliseconds: durationMilliseconds),
          Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut)
    ]);

    return ControlledAnimation(
      delay: Duration(seconds: delaySeconds, milliseconds: delayMilliseconds),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) =>
          Transform.scale(scale: animation['Scale'], child: child),
    );
  }
}
