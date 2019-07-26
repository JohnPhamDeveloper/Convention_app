import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/notification/NotificationItem.dart';
import 'dart:async';
import 'dart:math';

//DEBUG
final colorsMe = [Colors.red, Colors.orange, Colors.pink, Colors.green];
final textMe = ["RED", "ORANGE", "PINK", "GREEN"];

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  List<NotificationItem> currentNotifications;
  Timer timer;
  int debugIndex = 0;

  @override
  void initState() {
    super.initState();
    currentNotifications = List<NotificationItem>();

//  refresh timer for the age of the message
    timer = Timer.periodic(
      Duration(seconds: 5),
      (Timer t) => setState(
        () {},
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void addNewNotification(NotificationItem item) {
    // Add item
    setState(() {
      currentNotifications.insert(
        0,
        item,
      );
      debugIndex++; // O(n) since its moving all items down
    });
  }

  // Maybe the little bubble timer should manage itself rather than this whole widget?
//  List<Widget> getNewNotifications() {
//    print("RUN?");
//    if (currentNotifications.isEmpty) {
//      List<Text> empty = List<Text>();
//      empty.add(Text("Nothing here!"));
//      return empty;
//    }
//
////   List<NotificationItem> newNotifications = List<NotificationItem>();
////
////    // Return in reversed order
////    for (int i = currentNotifications.length - 1; i >= 0; i--) {
////      newNotifications.add(currentNotifications[i]);
////    }
//
////    for (int i = 0; i < currentNotifications.length; i++) {
////      newNotifications.add(currentNotifications[i]);
////    }
//
//    //setState(() {
//    //  currentNotifications = newNotifications;
//    //});
//
//    return currentNotifications;
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        // Debug button for push notification
        FlatButton(
          onPressed: () {
            addNewNotification(
              NotificationItem(
                iconColor: colorsMe[Random().nextInt(4)],
                message: debugIndex.toString(),
                index: debugIndex,
                timeSinceCreated: DateTime.now(),
                key: UniqueKey(),
              ),
            );
          },
          child: Text("press me"),
        ),
        // Listview of notifications
        Expanded(
          child: ListView.builder(
            itemCount: currentNotifications.length,
            itemBuilder: (context, index) {
              return currentNotifications[index];
            },
          ),
        ),
      ],
    );
  }
}
