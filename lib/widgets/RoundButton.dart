import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final icon;
  final onTap;

  RoundButton({@required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        onTap();
      },
      child: new Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 35.0,
      ),
      shape: new CircleBorder(),
      elevation: 3,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
    );
  }
}
