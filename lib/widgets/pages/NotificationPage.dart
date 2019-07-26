import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/notification/NotificationItem.dart';
import 'dart:async';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> ageOfNotifications;
  DatabaseReference database;
  FirebaseAuth _auth;
  Firestore _firestore;
  List<DateTime> timestamp;
  Timer timer;
  DateTime now;
  bool toggleChildrenToRebuild = false;
  int debugIndex = 0;

  @override
  void initState() {
    super.initState();
    currentNotifications = List<NotificationItem>();
    database = FirebaseDatabase.instance.reference();
    _auth = FirebaseAuth.instance;
    _firestore = Firestore.instance;
    getData();
//  refresh timer for the age of the message
//    timer = Timer.periodic(
//      Duration(seconds: 2),
//      (Timer t) => setState(
//        () {
//          toggleChildrenToRebuild = !toggleChildrenToRebuild;
//          print(toggleChildrenToRebuild);
//          print("REBUILD");
//          now = DateTime.now();
//          print(now);
//          // This will do the calcuations for the age for all messages
//          for(int i = 0; i < ageOfNotifications.length; i++){
//            timestamp.insert(0, element)
//          }
//        },
//      ),
//    );
  }

  void getData() async {
    print('signing in');
    FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: 'bob2@hotmail.com', password: '123456');
    if (user != null) {
      print("Signed in...");
      final QuerySnapshot querySnapshot = await Firestore.instance
          .collection("users")
          .where("name", isEqualTo: "Bobby Jones")
          .getDocuments();
      final List<DocumentSnapshot> documents = querySnapshot.documents;
      //  print(documents.length);
      print(documents[0].data);
//      CollectionReference ref = Firestore.instance.collection("users");
//      Stream<QuerySnapshot> snapshot =
//          ref.where("name", isEqualTo: "bobby jones").snapshots();
//
//      DocumentReference docRef =
//          Firestore.instance.collection("users").document();

//      final data =
//          snapshot.documents.map((document) => document['message']).toList();

      // print(data);
      //print(data);
      QuerySnapshot snapshot =
          await Firestore.instance.collection('users').getDocuments();

      for (DocumentSnapshot yes in snapshot.documents) {
        print(yes.data);
      }
      //print(snapshot.documents.first);
    }
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

      // Get timestamp for when this message is first created
      timestamp.insert(0, DateTime.now());

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
                toggleBuild: now,
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
