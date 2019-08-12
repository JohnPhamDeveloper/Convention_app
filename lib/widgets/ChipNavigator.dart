import 'package:flutter/material.dart';

class ChipNavigator extends StatefulWidget {
  final int navIndex;
  final Function onPressed;
  final bool enableShadows;
  final Color containerColor;
  final List<String> chipNames;
  final EdgeInsets padding;
  final MainAxisAlignment mainAxisAlignment;
  final EdgeInsets actionPadding;
  final Key key;

  ChipNavigator({
    @required this.navIndex,
    this.key,
    @required this.onPressed,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.actionPadding = const EdgeInsets.all(0.0),
    this.enableShadows = true,
    this.containerColor,
    @required this.chipNames,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
  }) : super(key: key);

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

  _renderContainerColor() {
    if (widget.containerColor == null) {
      return Colors.cyan[300];
    } else {
      return widget.containerColor;
    }
  }

  _renderShadow() {
    if (widget.enableShadows) {
      return BoxShadow(
        color: Colors.black12,
        blurRadius: 5.0,
        spreadRadius: 5.0,
        offset: Offset(0.0, 3.0),
      );
    } else {
      return BoxShadow(
        color: Colors.transparent,
        blurRadius: 0.0,
        spreadRadius: 0.0,
        offset: Offset(0.0, 0.0),
      );
    }
  }

  _generateChips() {
    List<Widget> createdChips = List<Widget>();
    for (int i = 0; i < widget.chipNames.length; i++) {
      createdChips.add(_actionChipWrap(widget.chipNames[i], i));
    }
    return createdChips;
  }

  Widget _actionChipWrap(String text, int index) {
    return Padding(
      padding: widget.actionPadding,
      child: ActionChip(
          label: Text(
            text,
            style: TextStyle(color: widget.navIndex == index ? enabledTextColor : disabledTextColor),
          ),
          onPressed: () {
            widget.onPressed(index);
          },
          backgroundColor: widget.navIndex == index ? enabledColor : disabledColor,
          pressElevation: widget.navIndex == index ? enabledPressElevation : disabledPressElevation,
          elevation: widget.navIndex == index ? enabledElevation : disabledElevation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _renderContainerColor(),
        //border: new Border.all(color: Colors.green, width: 5.0, style: BorderStyle.solid),
        boxShadow: <BoxShadow>[_renderShadow()],
      ),
      child: Padding(
        padding: widget.padding,
        child: Row(
          children: _generateChips(),
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}

//            _actionChipWrap("Cosplayers", 0),
//            _actionChipWrap("Photographers", 1),
//            _actionChipWrap("Con-goers", 2)
