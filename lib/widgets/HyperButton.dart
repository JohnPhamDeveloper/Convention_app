import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class HyperButton extends StatelessWidget {
  final text;
  final Function onTap;

  HyperButton({@required this.text, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
          ),
        );
      },
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            text,
            style: kTextStyleHyper(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
