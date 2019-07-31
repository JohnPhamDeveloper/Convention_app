import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

// Column widget which displays a title on top and an number on bottom
class TitleData extends StatelessWidget {
  final String title;
  final int number;
  final double width;

  TitleData({@required this.title, @required this.number, this.width});

  String convertNumberToString() {
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CircularBox(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.0),
          Text(
            convertNumberToString(),
            style: TextStyle(fontSize: 25.0, color: Colors.cyan[300], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
