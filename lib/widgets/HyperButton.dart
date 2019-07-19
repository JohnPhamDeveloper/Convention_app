import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class HyperButton extends StatelessWidget {
  final text;

  HyperButton({@required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
          ),
        );
      },
      child: Container(
        child: Text(
          text,
          style: kTextStyleHyper(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
