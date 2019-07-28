import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/HeroProfile.dart';

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
      image: url,
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
      return HeroProfile(
        userImages: userImageWidgets,
        name: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
        friendliness: loggedInUser.getHashMap[FirestoreManager.keyFriendliness],
        fame: loggedInUser.getHashMap[FirestoreManager.keyFame],
      );
    });
  }
}
