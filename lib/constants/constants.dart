import 'package:flutter/material.dart';

// Used for my custom animations
class REMOVE2 {
  static const FROM_LEFT = 1;
  static const FROM_RIGHT = -1;
}

enum AnimationDirection {
  FROM_LEFT,
  FROM_RIGHT,
  FROM_TOP,
  FROM_BOTTOM,
  TO_LEFT,
}

const kBoxGap = 20.0; // Gaps between each elements

TextStyle kTextStyleNotImportant() {
  return TextStyle(
    color: Colors.grey[600],
    fontSize: 14.0,
  );
}

TextStyle kTextStyleHyper() {
  return TextStyle(color: Colors.blue, fontSize: 14.0);
}

TextStyle kTextStyleImportant(BuildContext context) {
  return TextStyle(
    fontWeight: FontWeight.w400,
    color: Theme.of(context).accentColor,
  );
}
