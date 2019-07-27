import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cosplay_app/widgets/notification/NotificationDot.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

class ProfileStartPage extends StatefulWidget {
  @override
  _ProfileStartPageState createState() => _ProfileStartPageState();
}

class _ProfileStartPageState extends State<ProfileStartPage> {
  List<ImageContainer>
      userImageWidgets; // Widget that builds itself based on the photosURL information

  @override
  void initState() {
    super.initState();
    userImageWidgets = List<ImageContainer>();
  }

  ImageContainer createImageContainerWidgetFromURL(String url) {
    return ImageContainer(
      image: NetworkImage(url),
      height: double.infinity,
      width: double.infinity,
    );
  }

  // Generate image widgets for the carousel from the logged in users image references
  void updateUserImageWidgets(LoggedInUser loggedInUser) {
    List<ImageContainer> newUserImageWidgets = List<ImageContainer>();
    List<dynamic> urls = loggedInUser.getHashMap[FirestoreManager.keyPhotos];

    for (String url in urls) {
      newUserImageWidgets.add(createImageContainerWidgetFromURL(url));
    }

    userImageWidgets = newUserImageWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<LoggedInUser>(context);
    print(
        "--------------------------------------------------------------------");
    print(loggedInUser);
    return Consumer<LoggedInUser>(builder: (context, loggedInUser, child) {
      updateUserImageWidgets(loggedInUser);
      print("How often is profile start page rebuilding?");
      return Stack(
        children: <Widget>[
          // Carousel
          Swiper(
            itemBuilder: (BuildContext context, int index) {
              return userImageWidgets[index];
            },
            itemCount: userImageWidgets.length,
            pagination: SwiperPagination(
                alignment: Alignment.topCenter, builder: SwiperPagination.dots),
            control: SwiperControl(
              color: Colors.white,
            ),
          ),
          // User information bottom left
          Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconText(
                  icon: Icons.face,
                  text: Text(
                    loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
                    style: kProfileOverlayNameStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                IconText(
                  icon: Icons.sentiment_very_satisfied,
                  text: Text(
                    loggedInUser.getHashMap[FirestoreManager.keyFriendliness]
                        .toString(),
                    style: kProfileOverlayTextStyle,
                  ),
                ),
                SizedBox(height: 10.0),
                IconText(
                  icon: Icons.star,
                  text: Text(
                    loggedInUser.getHashMap[FirestoreManager.keyFame]
                        .toString(),
                    style: kProfileOverlayTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, top: 20.0),
              child: NotificationDot(innerColor: Colors.pinkAccent),
            ),
          ),
        ],
      );
    });
  }
}

final Color kTextStrokeColor = Colors.black12;
final double kTextStrokeBlur = 1.0;
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
        Stack(
          children: <Widget>[
            Positioned(
              left: 0.2,
              top: 0.2,
              child: Icon(icon, color: Colors.black12, size: iconSize + 2.0),
            ),
            Icon(icon, color: iconColor, size: iconSize),
          ],
        ),
        SizedBox(width: 10.0),
        text
      ],
    );
  }
}
