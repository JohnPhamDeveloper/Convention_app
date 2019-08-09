import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/widgets/notification/NotificationItem.dart';
import 'package:cosplay_app/classes/HeroCreator.dart';
import 'package:cosplay_app/widgets/MiniUser.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:math';

class NotificationPage extends StatefulWidget {
  final FirebaseUser firebaseUser;
  Timestamp t;

  NotificationPage({@required this.firebaseUser});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin {
  Timer timer;
  Queue<Widget> notifications = Queue<Widget>();
  Queue<Widget> prevNotifications = Queue<Widget>();
  bool loadedPreviousNotifications = false; // First launch app so need to load previous 20 notifications from database

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  _initAsync() async {
    // TODO First time loading this, push the 20 latest notification to the notifications queue
    await Firestore.instance.collection('private').document(widget.firebaseUser.uid).get().then((snapshot) async {
      if (snapshot.data['notifications'] != null) {
        final notificationLength = snapshot.data['notifications'].length;
        print('NotificationLength: $notificationLength');
        var start = notificationLength - 20 - 1;
        if (start < 0) start = 0;
        print('Start: $start');
        var numberOfNotificationsToShow = 15;
        if (notificationLength < numberOfNotificationsToShow) numberOfNotificationsToShow = notificationLength;
        print('number of notifications to show: $numberOfNotificationsToShow');

        // Load the recent 15 notifications only
        for (int i = start; i < start + numberOfNotificationsToShow; i++) {
          await _buildNotificationItem(snapshot.data['notifications'][i]);
        }
      }

      // Add a box at the end of the notifications so the last notification doesn't get blocked off
      notifications.add(SizedBox(height: 150));

      // Add new notifications every time they come in
      _listenToNotifications();
    });
  }

  _listenToNotifications() {
    Firestore.instance.collection("private").document(widget.firebaseUser.uid).snapshots().listen((snapshot) async {
      // Prevent this from being called on the initial page load
      // When we load the previous notifications, this will run on start, which causes the most recent notification
      // To be duplicated
      if (loadedPreviousNotifications) {
        print("DID THIS RUN?");
        // notifications.clear();
        //if (!snapshot.exists) return Text("Nothing loaded...");
        final lastItemIndex = snapshot.data['notifications'].length - 1;

        // Empty notification
        if (lastItemIndex >= 0) {
          //  Take latest notification and add it to beginning of queue
          await _buildNotificationItem(snapshot.data['notifications'][lastItemIndex]);
        }
      }
      loadedPreviousNotifications = true;
    });
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
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // Create a notification widget with the data from the database
  _buildNotificationItem(Map<dynamic, dynamic> data) async {
    Widget item;
    final timestamp = data['timeStamp'];
    String message = data['message'];
    String name = data['name'];
    String uid = data['uid'];

    // Normal notification
    if (uid == 'null') {
    }
    // User notification
    else {
      return Firestore.instance.collection('users').document(uid).get().then((snapshot) {
        String imageUrl = snapshot.data['photos'][0];
        int rarity = snapshot.data['rarityBorder'];
        // Add item
        item = NotificationItem(
          onTap: () {
            HeroCreator.pushProfileIntoView(snapshot.reference, context, widget.firebaseUser);
          },
          name: name,
          miniUser: MiniUser(
            width: 60.0,
            height: 60.0,
            imageURL: imageUrl,
            imageHeroName: imageUrl,
            enableSelfieDot: false,
            enableStatusDot: false,
            rarity: rarity,
          ),
          message: message,
          timeCreated: timestamp,
          key: UniqueKey(),
        );

        setState(() {
          notifications.addFirst(item);
        });
      }).catchError((error) {
        print("Unable to get other user information");
        print(error);
        // String created = timeago.format(date);

        item = NotificationItem(
          onTap: () {},
          name: "????",
          message: "Unable to get this user's information",
          timeCreated: timestamp,
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
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 70.0),
          child: Text(
            "Notifications",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
          ),
        ),
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
