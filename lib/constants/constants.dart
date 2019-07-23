import 'package:flutter/material.dart';

// Used for my custom animations
class REMOVE2 {
  static const FROM_LEFT = 1;
  static const FROM_RIGHT = -1;
}

enum AnimationDirection {
  LEFT,
  RIGHT,
  TOP,
  BOTTOM,
}

const kBoxGap = 20.0; // Gaps between each elements

// CARDS
const kCardGap = 18.0;
const kCardTitleStyle = TextStyle(
  color: Colors.white,
  fontSize: 25.0,
  fontWeight: FontWeight.w500,
);
const kCardPadding = 4.0;
const kRarityBorders = [
  Colors.blueGrey,
  Colors.green,
  Colors.deepPurpleAccent,
  Colors.deepOrangeAccent,
];

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
