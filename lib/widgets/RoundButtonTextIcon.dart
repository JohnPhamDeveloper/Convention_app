import 'package:flutter/material.dart';

// A rounded button with a icon and a text
class RoundButtonTextIcon extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color fillColor;
  final double width;
  final double height;
  final EdgeInsets padding;
  final Text text;

  RoundButtonTextIcon(
      {@required this.onTap,
      this.text,
      this.icon = Icons.build,
      this.fillColor = Colors.white,
      this.iconColor = Colors.white,
      this.width = 200.0,
      this.height = 200.0,
      this.iconSize = 25.0,
      this.padding = const EdgeInsets.all(16.0)});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      // constraints: BoxConstraints(minHeight: width, minWidth: height),
      onPressed: () {
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          SizedBox(width: 15.0),
          text,
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0))),
      elevation: 3,
      fillColor: fillColor,
      padding: padding,
    );
  }
}
