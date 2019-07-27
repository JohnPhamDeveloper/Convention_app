import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/notification/Bubble.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/constants/constants.dart';

class NotificationItem extends StatelessWidget {
  final Color iconColor;
  final String message;
  final Key key;
  final String timeSinceCreated;

  NotificationItem(
      {this.iconColor = Colors.pink,
      this.message = "Default test message.",
      this.key,
      this.timeSinceCreated})
      : super(key: key);

  String formattedTimer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Stack(
        children: <Widget>[
          // Icon and Text
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 20.0,
            ),
            child: Row(
              children: <Widget>[
                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            1.0, // has the effect of extending the shadow
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
                // Message
                Expanded(
                  child: Bubble(text: message),
                ),
              ],
            ),
          ),
          // Person name on bubble
          Positioned(
            top: 15,
            left: 90,
            child: CircularBox(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              radius: 20.0,
              child: Text(
                'Jonas Simpson',
                style: TextStyle(
                    color: kBlack, fontWeight: FontWeight.w600, fontSize: 14.0),
              ),
            ),
          ),
          // Timestamp
          Positioned(
            top: 17,
            left: 220,
            child: CircularBox(
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              radius: 20.0,
              child: Text(
                timeSinceCreated,
                style: TextStyle(
                    color: kBlack, fontWeight: FontWeight.w600, fontSize: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
