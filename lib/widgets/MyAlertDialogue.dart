import 'package:flutter/material.dart';

class MyAlertDialogue {
  static showDialogue(BuildContext context, Function onAccept, Function onDecline) {
    String text = "• Finish - Confirms selfie with other person \n\n"
        "• End - Cancels selfie \n\n";

    final myColor = Colors.pinkAccent;

    openAlertBox() {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          width: 300.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 15,
                top: -7,
                child: Container(
                  width: 40,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.black87,
                      size: 20.0,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Finish Selfie",
                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: myColor,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(0.0)),
                          ),
                          child: InkWell(
                            onTap: () {
                              onAccept();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Finish",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0.0), bottomRight: Radius.circular(32.0)),
                          ),
                          child: InkWell(
                            onTap: () {
                              onDecline();
                              Navigator.pop(context);
                            },
                            splashColor: Colors.white,
                            child: Text(
                              "End",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

//    final alert = AlertDialog(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
////      title: Text(
////        "Finish Selfie?",
////        textAlign: TextAlign.center,
////      ),
//      content: Container(
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.all(Radius.circular(20)),
//          color: Colors.orange,
//        ),
//        child: Text("My Text"),
//      ),
////      actions: <Widget>[button1, button2],
//    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return openAlertBox();
      },
    );
  }
}
