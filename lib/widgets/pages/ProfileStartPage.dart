import 'package:flutter/material.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';

class ProfileStartPage extends StatefulWidget {
  @override
  _ProfileStartPageState createState() => _ProfileStartPageState();
}

class _ProfileStartPageState extends State<ProfileStartPage> {
  List<dynamic> userImageUrls = List<dynamic>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Generate image widgets for the carousel from the logged in users image references
  void updateUserImageWidgets(LoggedInUser loggedInUser) {
    userImageUrls = loggedInUser.getHashMap[FirestoreManager.keyPhotos];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoggedInUser>(builder: (context, loggedInUser, child) {
      updateUserImageWidgets(loggedInUser);
      return HeroProfileStart(
        isLoggedInUser: true,
        userImages: userImageUrls,
        name: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
        friendliness: loggedInUser.getHashMap[FirestoreManager.keyFriendliness],
        fame: loggedInUser.getHashMap[FirestoreManager.keyFame],
      );
    });
  }
}
