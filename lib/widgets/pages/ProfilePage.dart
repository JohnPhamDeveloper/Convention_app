import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/1.jpg'),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 50.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RoundButton(
                icon: Icons.arrow_downward,
                onTap: () {
                  print("Show more profile");
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconText(
                icon: Icons.face,
                text: Text(
                  "Jenny Smith",
                  style: kProfileOverlayNameStyle,
                ),
              ),
              SizedBox(height: 10.0),
              IconText(
                icon: Icons.favorite,
                text: Text(
                  "1352",
                  style: kProfileOverlayTextStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final TextStyle kProfileOverlayNameStyle =
    TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700);

final TextStyle kProfileOverlayTextStyle =
    TextStyle(fontSize: 25.0, fontWeight: FontWeight.w400);

class IconText extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Text text;

  IconText(
      {@required this.icon,
      this.iconSize = 30.0,
      @required this.text,
      this.iconColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, color: iconColor, size: iconSize),
        SizedBox(width: 10.0),
        text
      ],
    );
  }
}
