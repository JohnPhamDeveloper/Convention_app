import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class UserSearchInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 6.0, top: 6.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            minRadius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text("TP"),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Tommy Pram",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600)),
                SizedBox(height: 5.0),
                Text("Bob - That one anime that has a obnoxiously long title",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[50])),
              ],
            ),
          ),
          SizedBox(width: 25.0),
          Row(
            children: <Widget>[
              Icon(Icons.sentiment_very_satisfied, color: Colors.grey[50]),
              SizedBox(width: 5.0),
              Text("1532"),
            ],
          ),
        ],
      ),
    );
  }
}
