import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:intl/intl.dart';

class MessagePage extends StatefulWidget {
  FirebaseUser firebaseUser;

  MessagePage({@required this.firebaseUser});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Message page will first show the chat rooms...
  // So we need to listen to the private collection for the current user and check the chatrooms
  List<Widget> rooms = List<Widget>();

  // Belongs to chatview
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    print("MESSAGE ==================================================");
    Firestore.instance.collection('private').document(widget.firebaseUser.uid).collection('rooms').snapshots().listen((snapshot) {
      // Get all the rooms this user is in (documentIds are the rooms)
      for (DocumentSnapshot snapshot in snapshot.documents) {
        String roomId = snapshot.documentID;
        print(snapshot.documentID);

        // What do I do with each room id?
        // Need to use the room id to look up where the chatroom is
        Firestore.instance.collection('chatrooms').document(roomId).get().then((snapshot) {
          if (snapshot.data['messages'].isNotEmpty) {
            List<String> usersInChat = List<String>();
            for (String userId in snapshot.data['users']) {
              usersInChat.add(userId);
            }
            print(usersInChat);
            Timestamp created = snapshot.data['created'];
            print(created);
            Timestamp recent = snapshot.data['recent'];
            print(recent);
//            List<Map<dynamic, dynamic>> messages = List<Map<dynamic, dynamic>>();
            // Construct a widget for the message page preview
            // Each message in the chat room
            for (Map<dynamic, dynamic> message in snapshot.data['messages']) {
              String name = message['name'];
              String text = message['message'];
              print(text);
              Timestamp sentAt = message['sentAt'];
              var dateFormat = DateFormat.yMd().add_jm();
              String sentDate = dateFormat.format(sentAt.toDate());
              print(sentAt);
              // Build a message widget with text
              print('ADDING ROOM');
              setState(() {
                rooms.add(room(text, name, sentDate, context));
              });
            }
          }
        });
      }
    });
  }

  Widget room(String message, String name, String sentDate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // pretend theres an image here
          Expanded(
            flex: 2,
            child: Container(width: 50, height: 50, color: Colors.pinkAccent),
          ),
          SizedBox(width: 20),
          // Name and recent text
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.0),
                Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ],
            ),
          ),
          // Time sent
          Expanded(
            flex: 4,
            child: Text(
              sentDate,
              style: TextStyle(color: Colors.white, fontSize: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  // TODO chatview should be pushed onto screen to avoid interaction with bottom nav bar
  Widget chatView() {
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // TEXT FIELD
            Expanded(
              child: TextField(
                controller: textController,
                style: new TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: 'Type message here!',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            // SEND BUTTON
            FlatButton(
              onPressed: () {
                //TODO send message to database
                // How? this chatroom should have access to its id
              },
              child: Text(
                "Send",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white, width: 2.0),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(height: 50, width: 50, color: Colors.pink),
      // Messages
      Column(
        children: rooms,
      ),
      Container(height: 50, width: 50, color: Colors.pink),
      //Textfield
      //  chatView()
    ]);
  }
}

//Row(
//children: <Widget>[
////        Text(
////          "Recent Conversations",
////          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
////        ),
//],
//);
