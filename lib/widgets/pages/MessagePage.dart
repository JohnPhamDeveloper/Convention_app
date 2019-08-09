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

    // Find chatrooms this user is in
    StreamSubscription subscription = Firestore.instance
        .collection('chatrooms')
        .where('users.${widget.firebaseUser.uid}', isEqualTo: true)
        .snapshots()
        .listen((snapshot) async {
      List<Map<dynamic, dynamic>> unsortedChatRooms = List<Map<dynamic, dynamic>>();
      setState(() {
        roomPreviews.clear();
      });
      // Get all chatrooms and create a preview
      for (DocumentSnapshot snapshot in snapshot.documents) {
        if (snapshot.data['messages'].length <= 0) return;
        await _getOtherUserPublicInformation(snapshot, unsortedChatRooms);
      }
      _sortRoomByTimestamp(unsortedChatRooms);
      _addRoomPreviewRecentFirst(unsortedChatRooms);
    });

    subscriptionList.add(subscription);
  }

  _getOtherUserPublicInformation(DocumentSnapshot snapshot, List<Map<dynamic, dynamic>> unsortedChatRooms) async {
    String roomId = snapshot.documentID;
    int lastMessageIndex = snapshot.data['messages'].length - 1;
    String circlePhotoUrl;
    String displayName;
    int rarity;
    Map<dynamic, dynamic> mostRecentMessage = snapshot.data['messages'][lastMessageIndex];
    Timestamp recent = snapshot.data['recent'];

    // Look for everyone that's not the logged in user and fetch their image
    for (String userId in snapshot.data['users'].keys) {
      // If the user isn't the logged in user...
      if (userId != widget.firebaseUser.uid) {
        // Get the user's photo
        await Firestore.instance.collection('users').document(userId).get().then((snapshot) {
          circlePhotoUrl = snapshot.data['photos'][0];
          displayName = snapshot.data['displayName'];
          rarity = snapshot.data['rarityBorder'];
        });
      }
    }

    var dateFormat = DateFormat.yMd().add_jm();

    //print(mostRecentMessage);
    // print("BEFORE ${mostRecentMessage['sentAt']}");
    // String mostRecentMessageTime = dateFormat.format(mostRecentMessage['sentAt'].toDate());
    String mostRecentMessageTime = dateFormat.format(recent.toDate());

    Map<dynamic, dynamic> userData = {
      'displayName': displayName,
      'message': mostRecentMessage['message'],
      'name': mostRecentMessage['name'],
      'mostRecentMessageTime': mostRecentMessageTime,
      'circlePhotoUrl': circlePhotoUrl,
      'roomId': roomId,
      'recent': recent,
      'rarity': rarity,
    };

    unsortedChatRooms.add(userData);
  }

  _sortRoomByTimestamp(List<Map<dynamic, dynamic>> unsortedChatRooms) {
    int minIndex;
    for (int i = 0; i < unsortedChatRooms.length; i++) {
      minIndex = i;
      for (int j = i + 1; j < unsortedChatRooms.length; j++) {
        Timestamp recentI = unsortedChatRooms[i]['recent'];
        Timestamp recentJ = unsortedChatRooms[j]['recent'];
        // J timestamp is greater than I timestamp (J is more recent); mark J as min
//        print(recentJ.millisecondsSinceEpoch);
//        print(recentI.millisecondsSinceEpoch);
        if (recentJ.millisecondsSinceEpoch > recentI.millisecondsSinceEpoch) minIndex = j;
      }
      // Swap min and I
      Map<dynamic, dynamic> pointerI = unsortedChatRooms[i];
      Map<dynamic, dynamic> pointerMin = unsortedChatRooms[minIndex];

      unsortedChatRooms[i] = pointerMin;
      unsortedChatRooms[minIndex] = pointerI;
    }
  }

  _addRoomPreviewRecentFirst(List<Map<dynamic, dynamic>> unsortedChatRooms) {
    for (int i = 0; i < unsortedChatRooms.length; i++) {
      setState(
        () {
          roomPreviews.add(
            room(
                unsortedChatRooms[i]['displayName'],
                unsortedChatRooms[i]['message'],
                unsortedChatRooms[i]['name'],
                unsortedChatRooms[i]['mostRecentMessageTime'],
                unsortedChatRooms[i]['circlePhotoUrl'],
                unsortedChatRooms[i]['roomId'],
                context,
                unsortedChatRooms[i]['rarity']),
          );
        },
      );
    }
  }

  Widget room(String displayName, String message, String name, String sentDate, String imageUrl, String roomId,
      BuildContext context, int rarity) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatView(
              loggedInUserName: displayName,
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
              rarity: rarity,
            ),
            SizedBox(width: 15),
            // Name and recent text
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    displayName,
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
    _listenToActiveChatrooms();
  }

  _listenToActiveChatrooms() {
    // Listen to the chatroom ID
    Firestore.instance.collection('chatrooms').document(widget.docId).snapshots().listen((snapshot) {
      // Map<dynamic, dynamic> messages = snapshot.data['messages'];

      messages.clear();
      //messages.add(SizedBox(height: 50));
      bool isFirstMessage = true;

      if (snapshot.exists) {
        for (Map<dynamic, dynamic> message in snapshot.data['messages']) {
          // SKip first message which is a welcome message
          if (isFirstMessage) {
            isFirstMessage = false;
            continue;
          }

          var dateFormat = DateFormat.yMd().add_jm();

          String sentAt = dateFormat.format(message['sentAt'].toDate());

          print(message['message']);
          String messageUid = message['uid'];
          bool isLoggedInUser = false;

          if (messageUid == widget.firebaseUser.uid) {
            isLoggedInUser = true;
          }

          messages.add(_createMessageWidget(message['message'], sentAt, isLoggedInUser));
        }
        messages.add(SizedBox(height: 30));
        final revMessages = messages.reversed.toList();
        revMessages.add(SizedBox(height: 50));

        // Get messages and timestamp of each messages
        //_createMessageWidget(message);
        setState(() {
          messages = revMessages;
        });
      }
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
