import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/widgets/notification/NotificationItem.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async';
import 'dart:math';

//DEBUG
final colorsMe = [Colors.red, Colors.orange, Colors.pink, Colors.green];
final textMe = ["RED", "ORANGE", "PINK", "GREEN"];
final randomText = [
  "Yo my boi wheres my shoes",
  "I dunno i go tlost in the woods and found my way out the next morning",
  "ya babe",
  "YOu eat cheese"
];

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  FirebaseAuth _auth;
  Timer timer;
  bool toggleChildrenToRebuild = false;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;

    beginRebuildEverySeconds(60);

    // DEBUG AND FOR LEARNING (though make sure the user is signed in)
    getData();
  }

  // We need the bubble to update the notifications age every second with the given value
  void beginRebuildEverySeconds(int seconds) {
    // Just an empty setstate call to trigger a rebuild
    timer = Timer.periodic(
      Duration(seconds: seconds),
      (Timer t) => setState(
        () {},
      ),
    );
  }

  void stopRebuildEverySeconds() {
    timer.cancel();
  }

  // DEBUG AND FOR LEARNING REFERENCE
  void getData() async {
    //print('signing in');
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: 'bob2@hotmail.com', password: '123456');
    if (user != null) {
      //print("Signed in...");
      final QuerySnapshot querySnapshot = await Firestore.instance
          .collection("users")
          .where("name", isEqualTo: "Bobby Jones")
          .getDocuments();
      final List<DocumentSnapshot> documents = querySnapshot.documents;

      final QuerySnapshot messageSnapshot = await Firestore.instance
          .collection("users")
          .document("jones")
          .collection("messages")
          .getDocuments();
      final List<DocumentSnapshot> messageDocuments = messageSnapshot.documents;
      //print(messageDocuments[0].data['timeSent'].seconds);

      // Get when the message was sent
      int seconds = messageDocuments[0].data['timeSent'].seconds;
      //print(messageDocuments[1].data);

      // This gets the correct time
      var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
//      print(date);
//      print(timeago.format(date));
//      //  print(documents.length);
//      print(documents[0].data);
//      print("Name: ${documents[0].data['name']}");
      // print("Registered: ${documents[0].data['registered']}");
//      QuerySnapshot snapshot =
//          await Firestore.instance.collection('users').getDocuments();
//
//      for (DocumentSnapshot yes in snapshot.documents) {
//        print(yes.data);
//      }
    }
  }

  @override
  void dispose() {
    stopRebuildEverySeconds();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // Create a notification item with the data from the database
  Widget buildNotificationItem(DocumentSnapshot documentSnapshot) {
    // Create a timestamp of when the message was sent
    int seconds = documentSnapshot.data['timeSent'].seconds;
    String message = documentSnapshot.data['message'];
    var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    String created = timeago.format(date);

    return NotificationItem(
      iconColor: colorsMe[Random().nextInt(4)],
      message: message,
      timeSinceCreated: created,
      key: UniqueKey(),
    );
  }

  // Debug purposes
  void testSendNotification() {
    Firestore.instance
        .collection("users")
        .document("jones")
        .collection("messages")
        .add({
      'message': randomText[Random().nextInt(randomText.length)],
      'timeSent': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        RaisedButton(
            onPressed: () {
              testSendNotification();
            },
            child: Text("CLICk")),
        StreamBuilder(
          stream: Firestore.instance
              .collection("users")
              .document('jones')
              .collection('messages')
              .snapshots(),
          builder: (context, snapshot) {
            // Nothing loaded yet
            if (!snapshot.hasData) return Text("Nothing loaded!");
            // print(snapshot.data.documents.length);
            // Go through every messages and store in notifications
            List<Widget> notifications = List<Widget>();
            for (DocumentSnapshot snapshot in snapshot.data.documents) {
              notifications.add(buildNotificationItem(snapshot));
            }

            // Reverse order so recent is on top
            notifications = notifications.reversed.toList();

            // Add a box at the end of the notifications so the last notification doesn't get blocked off
            notifications.add(SizedBox(height: 150));

            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.documents.length +
                    1, // + 1 is for the sized box
                itemBuilder: (context, index) {
                  return notifications[index];
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
