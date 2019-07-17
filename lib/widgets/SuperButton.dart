import 'package:flutter/material.dart';

class SuperButton extends StatelessWidget {
  final parentKey;
  final onPress;
  final validated;
  final text;

  SuperButton({this.parentKey, this.onPress, this.validated, this.text});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      child: RaisedButton(
        child: Container(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
        onPressed: () {
          if (validated()) {
            onPress();
          }
        },
      ),
    );
  }
}
