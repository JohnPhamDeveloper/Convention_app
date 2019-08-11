import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/IconText.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/HeroCreator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class RankCard extends StatefulWidget {
  final FirebaseUser firebaseUser;
  final DocumentSnapshot documentSnapshot;
  final String image;
  final String name;
  final int value;
  final int rarityBorder;
  final IconData icon;
  final bool dotIsOn;
  final Key key;

  RankCard({
    @required this.firebaseUser,
    @required this.documentSnapshot,
    @required this.image,
    @required this.name,
    @required this.icon,
    @required this.value,
    @required this.rarityBorder,
    @required this.dotIsOn,
    @required this.key,
  }) : super(key: key) {
    //createClickedProfileBeforeHand();
  }

  @override
  _RankCardState createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  Widget renderHeroDot() {
    return NotificationDot(
      outerSize: 25.0,
      innerSize: 25.0,
      innerColor: widget.dotIsOn ? Colors.pinkAccent : Colors.grey[50],
    );
  }

  void createClickedProfileOnlyOnTap(BuildContext context) {
    HeroCreator.pushProfileIntoView(widget.documentSnapshot.reference, context, widget.firebaseUser);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          createClickedProfileOnlyOnTap(context);
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3.0,
                  spreadRadius: 0.0,
                  offset: Offset(
                    7.0, // horizontal, move right 10
                    7.0, // vertical, move down 10
                  ),
                )
              ]),
              child: ImageContainer(
                  borderWidth: 3.5,
                  borderRadius: 25.0,
                  enableShadows: true,
                  rarityBorderColor: kRarityBorders[widget.rarityBorder],
                  width: 220,
                  imageURL: widget.image),
            ),
            // Dot
            Positioned(
              right: 13,
              top: 13,
              child: Container(child: renderHeroDot()),
            ),
            // Bottom Left
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconText(
                    icon: Icons.face,
                    iconSize: 25.0,
                    text: Text(
                      widget.name,
                      style: kProfileOverlayNameStyle,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  IconText(
                    icon: widget.icon,
                    iconSize: 25.0,
                    text: Text(
                      widget.value.toString(),
                      style: kProfileOverlayTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 20.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle =
    TextStyle(fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w700, shadows: kTextStrokeOutlines);

final Color kTextStrokeColor = Colors.black54;
final double kTextStrokeBlur = 5.0;
final List<Shadow> kTextStrokeOutlines = [
  Shadow(
// bottomLeft
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// bottomRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, -1.5),
      color: kTextStrokeColor),
  Shadow(
// topRight
      blurRadius: kTextStrokeBlur,
      offset: Offset(1.5, 1.5),
      color: kTextStrokeColor),
  Shadow(
// topLeftblur
      blurRadius: kTextStrokeBlur,
      offset: Offset(-1.5, 1.5),
      color: kTextStrokeColor),
];
