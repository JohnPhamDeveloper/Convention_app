import 'package:flutter/material.dart';

// Note that using this button with Font awesome will not align correctly in the center
class RoundButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final double iconSize;
  final EdgeInsets padding;
  final double size;
  final Color iconColor;

  RoundButton(
      {@required this.icon,
      this.onTap,
      this.iconSize = 35.0,
      this.padding = const EdgeInsets.all(16.0),
      this.size = 50.0,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints(minHeight: size, minWidth: size),
      onPressed: () {
        onTap();
      },
      child: Icon(
        icon,
        color: iconColor != null ? iconColor : Theme.of(context).primaryColor,
        size: iconSize,
      ),
      shape: CircleBorder(),
      elevation: 3,
      fillColor: Colors.white,
      padding: padding,
    );
  }
}
