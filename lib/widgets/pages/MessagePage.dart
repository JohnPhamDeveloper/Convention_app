import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:cosplay_app/widgets/MiniUser.dart';

class MessagePage extends StatefulWidget {
  FirebaseUser firebaseUser;

  MessagePage({@required this.firebaseUser});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  // Message page will first show the chat rooms...
  // So we need to listen to the private collection for the current user and check the chatrooms
  List<Widget> roomPreviews = List<Widget>();

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

        Firestore.instance.collection('chatrooms').document(roomId).get().then((snapshot) async {
          // We'll use the messages to get the most recent message in the chatroom
          // Which would be the last message in the array of maps
          if (snapshot.data['messages'].length <= 0) return;

          int lastMessageIndex = snapshot.data['messages'].length - 1;
          String photoUrl;

          // message, name, sentAt
          Map<dynamic, dynamic> message = snapshot.data['messages'][lastMessageIndex];

          // ??
          //snapshot.data['created']

          // When a message is sent, this field will update? Why not just get the most recent sentAt instead
          //snapshot.data['recent']

          // Users in the chatroom
          // So go through the array and look for everyone thats not the logged in user and fetch their image
          for (String userId in snapshot.data['users']) {
            // If the user isn't the logged in user...
            if (userId != widget.firebaseUser.uid) {
              // Get the user's photo
              await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
                photoUrl = snapshot.data['photos'][0];
              });
            }
          }

          var dateFormat = DateFormat.yMd().add_jm();
          String sentDate = dateFormat.format(message['sentAt'].toDate());

          // OK now we need to generate the chatroom preview with the information above, let's start with the photo
          setState(() {
            roomPreviews.add(room(message['message'], message['name'], sentDate, photoUrl, roomId, context));
          });

//          // This part is for the chatroomVIEW MOVE
//          if (snapshot.data['messages'].isNotEmpty) {
//            List<String> usersInChat = List<String>();
//            for (String userId in snapshot.data['users']) {
//              usersInChat.add(userId);
//            }
//            print(usersInChat);
//            Timestamp created = snapshot.data['created'];
//            print(created);
//            Timestamp recent = snapshot.data['recent'];
//            print(recent);
//            var dateFormat = DateFormat.yMd().add_jm();
//            String lastRoomUpdate = dateFormat.format(recent.toDate());
//
//            // In order to create the room preview we need to get the other persons image...
//            // The last message sent (can be either person)
//            // The timestamp of the most recent message (either person)
//            // Name of the OTHER person
//
//            //  _createRoomPreview(snapshot, roomId);
//          }
        });
      }
    });
  }

//  _createRoomPreview(DocumentSnapshot snapshot, String roomId) {
//    for (Map<dynamic, dynamic> message in snapshot.data['messages']) {
//      String name = message['name'];
//      String text = message['message'];
//      // String image = message['image'];
//      print(text);
////      Timestamp sentAt = message['sentAt'];
////      var dateFormat = DateFormat.yMd().add_jm();
////      String sentDate = dateFormat.format(sentAt.toDate());
////      print(sentAt);
//      // Build a message widget with text
//      print('ADDING ROOM');
//      setState(() {
//        roomPreviews.add(room(text, name, sentDate, image, roomId, context));
//      });
//    }
//  }

//  _wrapInScaffold(Widget room, BuildContext context) {
//    return Scaffold(
//      backgroundColor: Theme.of(context).primaryColor,
//      body: SafeArea(
//          child: Expanded(
//        child: ListView.builder(
//            itemCount: roomPreviews.length,
//            itemBuilder: (context, index) {
//              return roomPreviews[index];
//            }),
//      )),
//    );
//  }

  Widget room(String message, String name, String sentDate, String imageUrl, String roomId, BuildContext context) {
    return InkWell(
      onTap: () {
//        Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // pretend theres an image here
            MiniUser(
              enableSelfieDot: false,
              imageURL: imageUrl,
              width: 60,
              height: 60,
            ),
            SizedBox(width: 15),
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
      ),
    );
  }

  void _pushChatView() {}

  // TODO chatview should be pushed onto screen to avoid interaction with bottom nav bar
  Widget chatView() {
    return Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // TEXT FIELD
            Expanded(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLength: 200,
                maxLines: 2,
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
      SizedBox(height: 20.0),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 70.0),
        child: Text(
          "Recent Conversations",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
        ),
      ),
      SizedBox(height: 20.0),
      // Messages
//      Column(
//        children: rooms,
//      ),
      Expanded(
        child: ListView.builder(
            itemCount: roomPreviews.length,
            itemBuilder: (context, index) {
              return roomPreviews[index];
            }),
      ),
      //Textfield
//      chatView()
    ]);
  }
}
