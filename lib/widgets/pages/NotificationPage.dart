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

//DEBUG
//final colorsMe = [Colors.red, Colors.orange, Colors.pink, Colors.green];
//final textMe = ["RED", "ORANGE", "PINK", "GREEN"];
//final randomText = [
//  "Yo my boi wheres my shoes",
//  "I dunno i go tlost in the woods and found my way out the next morning",
//  "ya babe",
//  "YOu eat cheese"
//];

class NotificationPage extends StatefulWidget {
  final FirebaseUser firebaseUser;

  NotificationPage({@required this.firebaseUser});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with AutomaticKeepAliveClientMixin {
  Timer timer;
  //List<dynamic> notifications = List<dynamic>();
  Queue<Widget> notifications = Queue<Widget>();
  bool toggleChildrenToRebuild = false;
  bool recievedUsersInformation = false;

  @override
  void initState() {
    super.initState();

    // Add a box at the end of the notifications so the last notification doesn't get blocked off
    notifications.add(SizedBox(height: 150));

    // First time loading this, push the 20 latest notification to the notifications queue

    // _auth = FirebaseAuth.instance;

    //beginRebuildEverySeconds(60);

    // DEBUG AND FOR LEARNING (though make sure the user is signed in)
    //getData();

    // Add new notifications every time they come in
    _listenToNotifications();
  }

  _listenToNotifications() {
    Firestore.instance.collection("private").document(widget.firebaseUser.uid).snapshots().listen((snapshot) {
      //if (!snapshot.exists) return Text("Nothing loaded...");

      //  Take latest notification and add it to beginning of queue
      _buildNotificationItem(snapshot);
    });
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
    //print("Signed in...");
    final QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").where("name", isEqualTo: "Bobby Jones").getDocuments();
    final List<DocumentSnapshot> documents = querySnapshot.documents;

    final QuerySnapshot messageSnapshot =
        await Firestore.instance.collection("users").document("jones").collection("messages").getDocuments();
    final List<DocumentSnapshot> messageDocuments = messageSnapshot.documents;
    //print(messageDocuments[0].data['timeSent'].seconds);

    // Get when the message was sent
    // TODO Change back
    //int seconds = messageDocuments[0].data['timeSent'].seconds;
    int seconds = 1;
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

  @override
  void dispose() {
    stopRebuildEverySeconds();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // Create a notification item with the data from the database
  _buildNotificationItem(DocumentSnapshot documentSnapshot) {
    Widget item;
    final snapshotLength = documentSnapshot.data['notifications'].length;
    final lastItemIndex = snapshotLength - 1;
    print(snapshotLength);
    if (snapshotLength <= 0) return;

    final timestamp = documentSnapshot.data['notifications'][lastItemIndex]['timeStamp'];
    String message = documentSnapshot.data['notifications'][lastItemIndex]['message'];
    String name = documentSnapshot.data['notifications'][lastItemIndex]['name'];
    String uid = documentSnapshot.data['notifications'][lastItemIndex]['uid'];
    //var date = new DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);

    print('$timestamp $message $name $date');

    // Normal notification
    if (uid == 'null') {
    }
    // User notification
    else {
      // This is allowed since it's public information.
      // Client can modify it but won't really achieve anything other than getting public information
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

  // Debug purposes
//  void testSendNotification() {
//    Firestore.instance.collection("users").document("jones").collection("messages").add({
//      'message': "nonthing",
//      'timeSent': DateTime.now(),
//    });
//  }

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
