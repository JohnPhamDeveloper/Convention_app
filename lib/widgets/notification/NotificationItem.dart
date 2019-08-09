import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/notification/Bubble.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/MiniUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async';

class NotificationItem extends StatefulWidget {
  final MiniUser miniUser;
  final String name;
  final IconData icon;
  final Color iconColor;
  final String message;
  final Key key;
  final Timestamp timeCreated;
  final Function onTap;

  NotificationItem(
      {this.iconColor = Colors.pink,
      @required this.onTap,
      @required this.name,
      @required this.message,
      this.icon,
      @required this.key,
      @required this.timeCreated,
      this.miniUser})
      : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  // Maintain a timer that refreshes the timeCreated every 60 seconds
  // First create timer in initState
  // What next? Now we use the
  Timer refreshTimeAgoTimer;
  String newTimeAgo = 'loading...';

  @override
  void initState() {
    super.initState();

    // Refresh the age of the notifications
    var date = new DateTime.fromMillisecondsSinceEpoch(widget.timeCreated.millisecondsSinceEpoch);
    setState(() {
      newTimeAgo = timeago.format(date);
    });

    refreshTimeAgoTimer = Timer.periodic(Duration(seconds: 120), (Timer t) {
      // Get the timestamp from since the notification was created in database
      var date = new DateTime.fromMillisecondsSinceEpoch(widget.timeCreated.millisecondsSinceEpoch);

      // This will display the time ago since the notification was created
      setState(() {
        newTimeAgo = timeago.format(date);
      });
    });
  }

  @override
  void dispose() {
    refreshTimeAgoTimer.cancel();
    super.dispose();
  }

  Widget _renderMiniUserOrIcon() {
    if (widget.miniUser != null) {
      return widget.miniUser;
    } else {
      // render icon
      return Container(
        width: 60,
        height: 60,
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
        child: Icon(Icons.notifications, size: 30, color: widget.iconColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 20.0,
          ),
          child: Row(
            children: <Widget>[
              // Icon // Also where image should go
              _renderMiniUserOrIcon(),
              SizedBox(width: 15.0),
              // Message
              Expanded(child: Bubble(text: widget.message, name: widget.name, timeAgo: newTimeAgo)),
            ],
          ),
        ),
      ),
    );
  }
}
