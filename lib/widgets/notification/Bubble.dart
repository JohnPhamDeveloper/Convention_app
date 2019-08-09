import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBoxClipped.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

class Bubble extends StatelessWidget {
  final String text;
  final String name;
  final String timeAgo;

  Bubble({this.text, this.name, this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return CircularBoxClipped(
      topRight: Radius.circular(30.0),
      bottomRight: Radius.circular(30.0),
      bottomLeft: Radius.circular(30.0),
      topLeft: Radius.circular(30.0),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 3.0),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: kBlack, fontWeight: FontWeight.w500, fontSize: 15.0),
                children: [
                  TextSpan(text: text),
                ],
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            child: CircularBox(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              maxWidth: 100,
              radius: 20.0,
              // Name bubble
              child: Text(
                name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
            ),
          ),
          Positioned(
            top: -28,
            left: 150,
            child: CircularBox(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              radius: 20.0,
              child: Text(
                timeAgo,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kBlack, fontWeight: FontWeight.w600, fontSize: 10.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
