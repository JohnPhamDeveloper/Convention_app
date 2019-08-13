import 'package:flutter/material.dart';

class MyAlertDialogue {
  static showDialogue(BuildContext context) {
    String text = "• Finish - Verifies selfie with other person and then ends selfie\n\n"
        "• End - Cancels selfie\n\n";

    final button1 = FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      color: Colors.pinkAccent,
      child: Text(
        "Finish",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {},
    );
    final button2 = FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      color: Colors.pinkAccent,
      child: Text("End", style: TextStyle(color: Colors.white)),
      onPressed: () {},
    );
//    final button3 = FlatButton(
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
//      color: Colors.pinkAccent,
//      child: Text("Go Back", style: TextStyle(color: Colors.white)),
//      onPressed: () {},
//    );

    final myColor = Colors.pinkAccent;

    openAlertBox() {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        content: Container(
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Rate",
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.star_border,
                        color: myColor,
                        size: 30.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: myColor,
                        size: 30.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: myColor,
                        size: 30.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: myColor,
                        size: 30.0,
                      ),
                      Icon(
                        Icons.star_border,
                        color: myColor,
                        size: 30.0,
                      ),
                    ],
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
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Add Review",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: myColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                  ),
                  child: Text(
                    "Rate Product",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
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
