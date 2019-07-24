import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _current;

  final List<Widget> items = [
    ImageContainer(path: "assets/1.jpg"),
    ImageContainer(path: "assets/2.jpg"),
    ImageContainer(path: "assets/3.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        CarouselSlider(
          height: screenHeight - kBottomNavigationBarHeight,
          viewportFraction: 1.0,
          items: items,
          autoPlay: false,
          //aspectRatio: 1.0,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
        ),
        // Should'nt use icons need to draw circles, checkout how that carousel guy did it when site comes back online

        Row(
          children: <Widget>[
            Icon(FontAwesomeIcons.circle),
            Icon(
              FontAwesomeIcons.solidCircle,
              color: Colors.white,
            ),
            Icon(FontAwesomeIcons.circle),
            Icon(FontAwesomeIcons.circle),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15.0, bottom: 140.0),
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
          padding: const EdgeInsets.only(left: 20.0, bottom: 80.0),
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

final Color kTextStrokeColor = Colors.black;
final double kTextStrokeBlur = 3.0;
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

final TextStyle kProfileOverlayNameStyle = TextStyle(
  fontSize: 30.0,
  color: Colors.white,
  fontWeight: FontWeight.w700,
  shadows: kTextStrokeOutlines,
);

final TextStyle kProfileOverlayTextStyle = TextStyle(
    fontSize: 25.0,
    color: Colors.white,
    fontWeight: FontWeight.w400,
    shadows: kTextStrokeOutlines);

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

class ImageContainer extends StatelessWidget {
  final String path;

  ImageContainer({@required this.path});
  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: double.infinity,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(path),
          ),
        ),
      ),
    );
  }
}
