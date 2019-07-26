import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/notification/Bubble.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatefulWidget {
  final Color iconColor;
  final String message;
  final int index;
  final Key key;
  final DateTime timeSinceCreated;

  NotificationItem(
      {this.iconColor = Colors.pink,
      this.message = "Default test message.",
      this.index,
      this.key,
      this.timeSinceCreated})
      : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem>
    with AutomaticKeepAliveClientMixin {
  String formattedTimer;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    formattedTimer =
        timeago.format(widget.timeSinceCreated, locale: 'en_short');
    print(widget.key);
  }

  @override
  void dispose() {
    //timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(
        "How many times is this rebuilt??????-----------------------------------");
    print("timeSinceCreated[${widget.index}]: $widget.timeSinceCreated");
    print(
        "timeAgo: ${timeago.format(widget.timeSinceCreated, locale: 'en_short')}");
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
                  child: Icon(Icons.notifications,
                      size: 30, color: widget.iconColor),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Bubble(text: widget.message),
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
                timeago.format(widget.timeSinceCreated, locale: 'en_short'),
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
