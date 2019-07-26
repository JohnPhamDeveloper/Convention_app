import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBoxClipped.dart';
import 'package:cosplay_app/constants/constants.dart';

class Bubble extends StatelessWidget {
  final String text;

  Bubble({this.text});

  @override
  Widget build(BuildContext context) {
    return CircularBoxClipped(
      topRight: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
      topLeft: Radius.circular(30.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
                color: kBlack, fontWeight: FontWeight.w500, fontSize: 15.0),
            children: [
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }
}
