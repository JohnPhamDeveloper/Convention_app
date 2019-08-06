import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/widgets/notification/NotificationItem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cosplay_app/widgets/MiniUser.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:math';

class NotificationPage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  NotificationPage({@required this.firebaseUser});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin {
  Timer timer;
  Queue<Widget> notifications = Queue<Widget>();
  bool loadedPreviousNotifications = false; // First launch app so need to load previous 20 notifications from database
//  bool toggleChildrenToRebuild = false;
  // bool recievedUsersInformation = false;

  @override
  void initState() {
    super.initState();
    // TODO First time loading this, push the 20 latest notification to the notifications queue
    Firestore.instance.collection('private').document(widget.firebaseUser.uid).get().then((snapshot) {
      final notificationLength = snapshot.data['notifications'].length - 1;
      final start = notificationLength - 20;
      var numberOfNotificationsToShow = 15;

      // If the notifications isn't long as the number of notifications to show, then just
      // show the notificationLength instead
      if (notificationLength < numberOfNotificationsToShow) numberOfNotificationsToShow = notificationLength;

      // Load the recent 15 notifications only
      for (int i = start; i < start + numberOfNotificationsToShow; i++) {
        _buildNotificationItem(snapshot.data['notifications'][i]);
      }
    });

    // Add a box at the end of the notifications so the last notification doesn't get blocked off
    notifications.add(SizedBox(height: 150));

    // Updates the time ago for each notification
    _rebuildEverySeconds(60);

    // DEBUG AND FOR LEARNING (though make sure the user is signed in)
    //getData();

    // Add new notifications every time they come in
    _listenToNotifications();
  }

  _listenToNotifications() {
    Firestore.instance.collection("private").document(widget.firebaseUser.uid).snapshots().listen((snapshot) {
      //if (!snapshot.exists) return Text("Nothing loaded...");
      final lastItemIndex = snapshot.data['notifications'].length - 1;

      // Empty notification
      if (lastItemIndex >= 0) {
        //  Take latest notification and add it to beginning of queue
        _buildNotificationItem(snapshot.data['notifications'][lastItemIndex]);
      }
    });
  }

  void _rebuildEverySeconds(int seconds) {
    timer = Timer.periodic(
      Duration(seconds: seconds),
      (Timer t) => setState(
        () {},
      ),
    );
  }

  void _stopRebuildEverySeconds() {
    timer.cancel();
  }

//  // DEBUG AND FOR LEARNING REFERENCE (not used)
//  void getData() async {
//    //print("Signed in...");
//    final QuerySnapshot querySnapshot =
//        await Firestore.instance.collection("users").where("name", isEqualTo: "Bobby Jones").getDocuments();
//    final List<DocumentSnapshot> documents = querySnapshot.documents;
//
//    final QuerySnapshot messageSnapshot =
//        await Firestore.instance.collection("users").document("jones").collection("messages").getDocuments();
//    final List<DocumentSnapshot> messageDocuments = messageSnapshot.documents;
//    //print(messageDocuments[0].data['timeSent'].seconds);
//
//    // Get when the message was sent
//    // TODO Change back
//    //int seconds = messageDocuments[0].data['timeSent'].seconds;
//    int seconds = 1;
//    //print(messageDocuments[1].data);
//
//    // This gets the correct time
//    var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
////      print(date);
////      print(timeago.format(date));
////      //  print(documents.length);
////      print(documents[0].data);
////      print("Name: ${documents[0].data['name']}");
//    // print("Registered: ${documents[0].data['registered']}");
////      QuerySnapshot snapshot =
////          await Firestore.instance.collection('users').getDocuments();
////
////      for (DocumentSnapshot yes in snapshot.documents) {
////        print(yes.data);
////      }
//  }

  @override
  void dispose() {
    _stopRebuildEverySeconds();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // Create a notification widget with the data from the database
  _buildNotificationItem(Map<dynamic, dynamic> data) {
    Widget item;
    // final snapshotLength = data['notifications'].length;
//    final lastItemIndex = snapshotLength - 1;
//    print(snapshotLength);
//    if (snapshotLength <= 0) return;

    final timestamp = data['timeStamp'];
    String message = data['message'];
    String name = data['name'];
    String uid = data['uid'];
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    print('$timestamp $message $name $date');

    // Normal notification
    if (uid == 'null') {
    }
    // User notification
    else {
      // This is allowed since it's public information.
      // Client can modify it, but won't really achieve anything other than getting public information
      Firestore.instance.collection('users').document(uid).get().then((snapshot) {
        String imageUrl = snapshot.data['photos'][0];
        print(imageUrl);
        int rarity = snapshot.data['rarityBorder'];
        print(rarity);
        String created = timeago.format(date);
        print("Added new other user");
        // Add item
        item = NotificationItem(
          name: name,
          miniUser: MiniUser(
            width: 60.0,
            height: 60.0,
            imageURL: imageUrl,
            imageHeroName: imageUrl,
            enableSelfieDot: true,
            rarity: rarity,
          ),
          message: message,
          timeSinceCreated: created,
          key: UniqueKey(),
        );

        setState(() {
          notifications.addFirst(item);
        });
      }).catchError((error) {
        print("Unable to get other user information");
        print(error);
        String created = timeago.format(date);

        item = NotificationItem(
          name: "????",
          message: "Unable to get this user's information",
          timeSinceCreated: created,
          key: UniqueKey(),
        );
        setState(() {
          notifications.addFirst(item);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return notifications.elementAt(index);
            },
          ),
        )
      ],
    );
  }
}
