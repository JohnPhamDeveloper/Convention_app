import 'package:flutter/material.dart';
import 'package:cosplay_app/animations/AnimateOut.dart';
import 'package:cosplay_app/animations/AnimateIn.dart';

class MyAnimation {
  AnimationController controller;
  Widget nextAnimationToPlay;
  Widget child;

  // Needs changing?
  final double oStart;
  final bool shouldAnimateOpacity;

  // CONSTRUCTOR
  MyAnimation(
      {@required this.child,
      this.oStart = 0.0,
      this.shouldAnimateOpacity = false}) {
    nextAnimationToPlay =
        AnimateOut(myChild: child, controller: controller, start: oStart);
  }

  void setNextAnimation() {
//    nextAnimationToPlay = AnimateIn()
  }
}
