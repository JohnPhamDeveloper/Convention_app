import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/RoundButtonTextIcon.dart';

class ActionButton extends StatelessWidget {
  final Color fillColor;
  final Text text;
  final IconData icon;
  final Function onTap;
  final Color iconColor;

  ActionButton(
      {this.fillColor,
      this.text,
      @required this.onTap,
      this.icon,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: kButtonPaddingLeft, right: kButtonPaddingRight),
      child: RoundButtonTextIcon(
          text: text,
          fillColor: fillColor,
          icon: icon,
          iconColor: iconColor,
          onTap: () {
            // todo handle selfie request button
            onTap();
          }),
    );
  }
}

// Both buttons
const double kButtonPaddingLeft = 30.0;
const double kButtonPaddingRight = 30.0;

// Pink buttons
const TextStyle kButtonActionTextStyle =
    TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.white);

// White buttons
const TextStyle kButtonNormalTextStyle = TextStyle(
    fontWeight: FontWeight.w500, fontSize: 22.0, color: Colors.black54);
const kButtonNormalFillColor = Colors.white;
const kButtonNormalIconColor = Colors.black54;
