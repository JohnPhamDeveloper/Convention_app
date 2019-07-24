import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

class UserSearchInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            minRadius: 30.0,
            backgroundColor: Colors.blueAccent,
            child: Text("TP"),
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Tommy Pram", style: kTextStyleImportant(context)),
              Text(
                "Cosplay: Bob from Cheangu",
                style: kTextStyleImportant(context),
              ),
            ],
          ),
          SizedBox(width: 25.0),
          Row(
            children: <Widget>[
              Icon(Icons.sentiment_very_satisfied, color: Colors.pink),
              SizedBox(width: 5.0),
              Text("1532"),
            ],
          ),
        ],
      ),
    );
  }
}
