import 'package:flutter/material.dart';

class SuperButtonForm extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Key parentKey;
  final Function onPress;
  final Function validated;
  final String text;

  SuperButtonForm(
      {this.parentKey,
      this.onPress,
      this.validated,
      this.text,
      this.width = double.infinity,
      this.height = 50.0,
      this.color = Colors.pink});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      buttonColor: color,
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 5,
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
