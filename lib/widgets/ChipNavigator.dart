import 'package:flutter/material.dart';

class ChipNavigator extends StatefulWidget {
  final int navIndex;
  final Function onPressed;

  ChipNavigator({@required this.navIndex, @required this.onPressed});

  @override
  _ChipNavigatorState createState() => _ChipNavigatorState();
}

class _ChipNavigatorState extends State<ChipNavigator> {
  final Color enabledColor = Colors.pinkAccent;
  final Color enabledTextColor = Colors.white;
  final double enabledPressElevation = 0.0;
  final double enabledElevation = 5.0;
  final Color disabledColor = Colors.white;
  final Color disabledTextColor = Colors.black54;
  final double disabledPressElevation = 5.0;
  final double disabledElevation = 0.0;

  Widget _actionChipWrap(String text, int index) {
    return ActionChip(
        label: Text(
          text,
          style: TextStyle(color: widget.navIndex == index ? enabledTextColor : disabledTextColor),
        ),
        onPressed: () {
          widget.onPressed(index);
        },
        backgroundColor: widget.navIndex == index ? enabledColor : disabledColor,
        pressElevation: widget.navIndex == index ? enabledPressElevation : disabledPressElevation,
        elevation: widget.navIndex == index ? enabledElevation : disabledElevation);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: <Widget>[
          _actionChipWrap("Cosplayers", 0),
          _actionChipWrap("Photographers", 1),
          _actionChipWrap("Con-goers", 2)
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
