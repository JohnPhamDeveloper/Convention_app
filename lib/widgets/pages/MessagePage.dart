import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:cosplay_app/widgets/MiniUser.dart';
import 'dart:async';
import 'package:cosplay_app/widgets/native_shapes/CircularBoxClipped.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/classes/Meetup.dart';

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
  List<StreamSubscription> subscriptionList = List<StreamSubscription>();

  @override
  void initState() {
    super.initState();

    print("================================== MESSAGE ==================================================");
    Firestore.instance.collection('private').document(widget.firebaseUser.uid).collection('rooms').snapshots().listen((snapshot) {
      // Whenever the private->rooms changes, clear all current chatrooms->roomId listeners and remake them
      for (StreamSubscription sub in subscriptionList) {
        if (sub != null) {
          sub.cancel();
        }
      }

      List<Map<dynamic, dynamic>> unsortedData = List<Map<dynamic, dynamic>>();

      // Get all the rooms this user is in (documentIds are the rooms)
      for (DocumentSnapshot snapshot in snapshot.documents) {
        String roomId = snapshot.documentID;

        // if rooms does change, (removed or added), then the user will only get those new rooms now.
        StreamSubscription subscription =
            Firestore.instance.collection('chatrooms').document(roomId).snapshots().listen((snapshot) async {
          // We'll use the messages to get the most recent message in the chatroom
          // Which would be the last message in the array of maps
          if (snapshot.data['messages'].length <= 0) return;

          setState(() {
            print("TRYING TO CLEAR ROOMS");
            roomPreviews.clear();
          });

          int lastMessageIndex = snapshot.data['messages'].length - 1;
          String circlePhotoUrl;
          String displayName;

          // message, name, sentAt
          Map<dynamic, dynamic> mostRecentMessage = snapshot.data['messages'][lastMessageIndex];

          // So go through the array and look for everyone thats not the logged in user and fetch their image
          for (String userId in snapshot.data['users']) {
            // If the user isn't the logged in user...
            if (userId != widget.firebaseUser.uid) {
              // Get the user's photo
              await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
                circlePhotoUrl = snapshot.data['photos'][0];
                displayName = snapshot.data['displayName'];
              });
            }
          }

          var dateFormat = DateFormat.yMd().add_jm();

          print(mostRecentMessage);
          print("BEFORE ${mostRecentMessage['sentAt']}");
          String mostRecentMessageTime = dateFormat.format(mostRecentMessage['sentAt'].toDate());

          // Need to add all the values in a map, then sort the maps, and then create the Widgets after
          unsortedData.add({
            'displayName': displayName,
            'message': mostRecentMessage['message'],
            'name': mostRecentMessage['name'],
            'mostRecentMessageTime': mostRecentMessageTime,
            'circlePhotoUrl': circlePhotoUrl,
            'roomId': roomId
          });

          print("how many times");
          print(unsortedData);

          setState(() {
            roomPreviews.add(room(displayName, mostRecentMessage['message'], mostRecentMessage['name'], mostRecentMessageTime,
                circlePhotoUrl, roomId, context));
          });
        });

        subscriptionList.add(subscription);
      }

      // Sort here
      for (int i = 0; i < unsortedData.length; i++) {
        print("?");
        print(unsortedData[i]);
      }
    });

    // Initially setup a listener for all those rooms...
    // But what if a chatroom is deleted?
    // We shouldnt be able to listen to that room anymore
    // So the user->rooms listener should remove it from the array...
    // What we can do is just create a listener for each and then when the room listenr is called,
    // Clear all listeners and create new ones
//    Firestore.instance.collection('chatrooms').document(roomId).snapshots().listen((snapshot) async {
//      if (snapshot.data['messages'].length <= 0) return;
//
//      int lastMessageIndex = snapshot.data['messages'].length - 1;
//      String circlePhotoUrl;
//
//      Map<dynamic, dynamic> mostRecentMessage = snapshot.data['messages'][lastMessageIndex];
//
//      for (String userId in snapshot.data['users']) {
//        // If the user isn't the logged in user...
//        if (userId != widget.firebaseUser.uid) {
//          // Get the user's photo
//          await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
//            circlePhotoUrl = snapshot.data['photos'][0];
//          });
//        }
//      }
//
//      var dateFormat = DateFormat.yMd().add_jm();
//      String mostRecentMessageTime = dateFormat.format(mostRecentMessage['sentAt'].toDate());
//
//      setState(() {
//        roomPreviews.add(room(
//            mostRecentMessage['message'], mostRecentMessage['name'], mostRecentMessageTime, circlePhotoUrl, roomId, context));
//      });
//    });
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

  Widget room(String loggedInUserName, String message, String name, String sentDate, String imageUrl, String roomId,
      BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              loggedInUserName: loggedInUserName,
              docId: roomId,
              firebaseUser: widget.firebaseUser,
            ),
          ),
        );
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
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    message,
                    overflow: TextOverflow.ellipsis,
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

  @override
  void dispose() {
    for (StreamSubscription sub in subscriptionList) {
      sub.cancel();
    }
    super.dispose();
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
      SizedBox(height: 10.0),
      Expanded(
        child: ListView.builder(
            itemCount: roomPreviews.length,
            itemBuilder: (context, index) {
              return roomPreviews[index];
            }),
      ),
    ]);
  }
}

//
//
//
//
//
//

class ChatView extends StatefulWidget {
  final String loggedInUserName;
  final String docId;
  final FirebaseUser firebaseUser;

  ChatView({@required this.docId, @required this.firebaseUser, @required this.loggedInUserName});

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  // Belongs to chatview
  TextEditingController textController = TextEditingController();
  List<Widget> messages = List<Widget>();
  StreamSubscription sub;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Listen to the chatroom ID
    Firestore.instance.collection('chatrooms').document(widget.docId).snapshots().listen((snapshot) {
      // Map<dynamic, dynamic> messages = snapshot.data['messages'];

      messages.clear();
      //messages.add(SizedBox(height: 50));

      for (Map<dynamic, dynamic> message in snapshot.data['messages']) {
        var dateFormat = DateFormat.yMd().add_jm();

        String sentAt = dateFormat.format(message['sentAt'].toDate());

        print(message['message']);
        String messageUid = message['uid']; //TODO need UID to identiy whos talking
        bool isLoggedInUser = false;

        if (messageUid == widget.firebaseUser.uid) {
          isLoggedInUser = true;
        }

        // setState(() {
        messages.add(_createMessageWidget(message['message'], sentAt, isLoggedInUser));
        //   });

      }
      messages.add(SizedBox(height: 30));
      final revMessages = messages.reversed.toList();
      revMessages.add(SizedBox(height: 50));

      // Get messages and timestamp of each messages
      //_createMessageWidget(message);
      setState(() {
        messages = revMessages;
      });
    });
  }

  Widget _createMessageWidget(String message, String sentAt, bool isLoggedInUser) {
    return Align(
      alignment: isLoggedInUser
          ? Alignment.centerRight
          : Alignment.centerLeft, //TODO DEPENDING ON WHETHER ITS CURRENT USER OR OTHER USER
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: !isLoggedInUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '$sentAt',
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 5.0),
            CircularBoxClipped(
              topRight: !isLoggedInUser ? Radius.circular(20.0) : Radius.circular(0.0),
              topLeft: !isLoggedInUser ? Radius.circular(0.0) : Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              child: Text(
                '$message',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createChatView(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            reverse: true,
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return messages[index];
            },
          ),
        ),
//        messages[0],
//        messages[1],
//        messages[2],
        inputField(context),
      ],
    );
  }

  // TODO chatview should be pushed onto screen to avoid interaction with bottom nav bar
  Widget inputField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.white),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // TEXT FIELD
          Expanded(
            child: TextField(
              onTap: () {
//                scrollController.animateTo(scrollController.position.maxScrollExtent,
//                    duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
              },
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              // maxLength: 200,
              maxLines: 1,
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
              // Look for chatroomid of this room in database
              // Then send message to database
//              Firestore.instance.collection('chatrooms').document(widget.docId).updateData({
//                'messages': FieldValue.arrayUnion(["test"]),
//              });
              Map<dynamic, dynamic> arguments = Map<dynamic, dynamic>();
              arguments['message'] = textController.text;
              arguments['roomId'] = widget.docId;
              arguments['name'] = widget.loggedInUserName;
              print('sending... $arguments');
              final response = Meetup.sendMessage(arguments);
              print(response);
              textController.clear();
              FocusScope.of(context).requestFocus(new FocusNode());
//              scrollController.animateTo(scrollController.position.maxScrollExtent,
//                  duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
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
    );
  }

  @override
  void dispose() {
    if (sub != null) sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _createChatView(context),
              // Back arrow
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 15.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: RoundButton(
                    size: 40,
                    padding: EdgeInsets.all(0),
                    icon: Icons.arrow_back,
                    iconSize: 25.0,
                    iconColor: Colors.white,
                    fillColor: Colors.pinkAccent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
