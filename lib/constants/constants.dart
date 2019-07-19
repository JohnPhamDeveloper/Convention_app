import 'package:flutter/material.dart';

// Used for my custom animations
class AnimationDirection {
  static const FROM_LEFT = 1;
  static const FROM_RIGHT = -1;
}

const kBoxGap = 15.0; // Gaps between each elements

TextStyle kTextStyleNotImportant() {
  return TextStyle(
    color: Colors.grey[600],
  );
}

TextStyle kTextStyleImportant(BuildContext context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Theme.of(context).accentColor,
  );
}
