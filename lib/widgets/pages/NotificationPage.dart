import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/CircularBoxClipped.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        NotificationItem(
          iconColor: Colors.orange,
        ),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(
            iconColor: Colors.blue,
            message: "Wants to meetup with you for a gathering!"),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        NotificationItem(),
        SizedBox(height: 40.0),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final Color iconColor;
  final String message;

  NotificationItem(
      {this.iconColor = Colors.pink, this.message = "Default test message"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        left: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 1.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: Icon(Icons.notifications, size: 30, color: iconColor),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: CircularBoxClipped(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                topLeft: Radius.circular(30.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    message,
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
