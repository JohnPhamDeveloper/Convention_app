import "package:flutter/material.dart";
import 'package:cosplay_app/widgets/pages/RankingListPage.dart';
import 'package:cosplay_app/widgets/pages/SearchPage.dart';
import 'package:cosplay_app/widgets/pages/FamePage.dart';
import 'package:cosplay_app/widgets/pages/NotificationPage.dart';
import 'package:cosplay_app/widgets/pages/ProfilePage.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/widgets/LoadingIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LoggedInUser loggedInUser;
  bool loadedUserData = false;
  PreloadPageController preloadPageController;
  CircularBottomNavigationController _navigationController;
  bool playProfilePageCarousel = false;
  int navIndex = 0;
  PreloadPageView pageView;
  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.pinkAccent),
    TabItem(Icons.search, "Search", Colors.pinkAccent),
    TabItem(Icons.business_center, "Rewards", Colors.pinkAccent),
    TabItem(Icons.notifications, "Alerts", Colors.pinkAccent),
    TabItem(Icons.person, "Profile", Colors.pinkAccent),
  ]);

  @override
  void initState() {
    super.initState();
    loggedInUser = LoggedInUser();
    preloadPageController = PreloadPageController(initialPage: navIndex);
    _navigationController = CircularBottomNavigationController(navIndex);
    pageView = PreloadPageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      preloadPagesCount: 5,
      physics: new NeverScrollableScrollPhysics(),
      controller: preloadPageController,
      children: <Widget>[
//        RankingListPage(),
        SearchPage(),
//        FamePage(),
//        NotificationPage(),
        //  ProfilePage(),
      ],
    );

    // Get data from database for logged in user when it changes
    // Set loading is called if data is successfuly updated into loggedInUser
    _loginUser();

    //createMockUser();
  }

  // TODO REMOVE TEST
  //
  _loginUser() async {
    //  print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob@hotmail.com', password: '123456').then((user) {
      print("Successfully logged in");
      FirestoreManager.streamUserData(loggedInUser, setLoading, user.uid);
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  // TODO REMOVE TEST
  _loginUser2() async {
    // print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob2@hotmail.com', password: '123456').then((user) {
      print("Successfully logged in");
      FirestoreManager.streamUserData(loggedInUser, setLoading, user.uid);
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  // TODO DELEETE THIS MOCK USER
  void createMockUser() async {
    List<String> photoUrls = ["https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d"];
    List<String> urls = ["https://c.pxhere.com/images/c7/21/c8e22db330eb09e78970ac8b2ce2-1456325.jpg!d"];

    List<String> urls2 = ["https://c.pxhere.com/images/52/27/c8e31718a7e13b915f72689e7911-1424101.jpg!d"];

    List<String> urls3 = [
      "https://c.pxhere.com/photos/9d/fd/photographer_camera_photo_photos_foto_lens_take_a_photograph_electronic_equipment-942701.jpg!d"
    ];

    List<String> urls4 = [
      "https://c.pxhere.com/photos/b3/2d/camera_digital_equipment_female_girl_isolated_lens_people-1260617.jpg!d"
    ];

    List<String> urls5 = ["https://c.pxhere.com/photos/08/97/photographer_road_camera_girl_person-180399.jpg!d"];

    List<String> urls6 = ["https://c.pxhere.com/photos/62/c1/camera_photographer_person_photography_urban-133163.jpg!d"];

    List<String> urls7 = [
      "https://c.pxhere.com/photos/64/b4/photographer_photography_digital_camera_dslr_camera_digital_single_lens_reflex_camera_camera-964918.jpg!d"
    ];

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser10",
      fame: 45,
      friendliness: 512,
      displayName: "Netarno",
      photoUrls: photoUrls,
      cosplayName: "Netarno",
      seriesName: "Naruto",
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 3,
      realName: "Bobby Jones",
      cosplayerCost: "\$52.00/hr",
      photographerCost: "\$42.00/hr",
      photographyMonthsExperience: 2,
      photographyYearsExperience: 5,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser11",
      fame: 66,
      friendliness: 512,
      displayName: "Renaldo",
      cosplayName: "Gaia",
      seriesName: "Final Fantasy",
      photoUrls: urls,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 2,
      realName: "Bobby Jones",
      cosplayerCost: "\$12.00/hr",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 3,
      photographyYearsExperience: 7,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser12",
      fame: 32,
      friendliness: 783,
      displayName: "Chibata",
      cosplayName: "Luke",
      seriesName: "Tales of Abyss",
      photoUrls: urls2,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 1,
      realName: "Bobby Jones",
      cosplayerCost: "",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 4,
      photographyYearsExperience: 1,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser13",
      fame: 74,
      friendliness: 52,
      displayName: "Peronoa",
      cosplayName: "Nago",
      seriesName: "Tree Hunters",
      photoUrls: urls3,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 1,
      realName: "Bobby Jones",
      cosplayerCost: "\$62.00/hr",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 2,
      photographyYearsExperience: 6,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser14",
      fame: 82,
      friendliness: 74,
      displayName: "Peronoa",
      cosplayName: "Nago",
      seriesName: "Tree Hunters",
      photoUrls: urls4,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 2,
      realName: "Bobby Jones",
      cosplayerCost: "",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 2,
      photographyYearsExperience: 3,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser15",
      fame: 727,
      friendliness: 193,
      displayName: "Gueon",
      cosplayName: "Beqna",
      seriesName: "Attack On Titan",
      photoUrls: urls5,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 3,
      realName: "Bobby Jones",
      cosplayerCost: "",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 4,
      photographyYearsExperience: 1,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );

    await FirestoreManager.createUserInDatabase(
      documentName: "testUser16",
      fame: 273,
      friendliness: 472,
      displayName: "LooLoo",
      cosplayName: "Teeno",
      seriesName: "Original Cosplay",
      photoUrls: urls7,
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 0,
      realName: "Bobby Jones",
      cosplayerCost: "\$24.00/hr",
      photographerCost: '\$42.00/hr',
      photographyMonthsExperience: 3,
      photographyYearsExperience: 2,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );
//    await Firestore.instance.collection("users").document("testUser2").setData({
//      FirestoreManager.keyFame: 45,
//      FirestoreManager.keyFriendliness: 512,
//      FirestoreManager.keyDisplayName: "Netarno",
//      FirestoreManager.keyPhotos: [
//        "https://c.pxhere.com/photos/bb/92/boy_portrait_people_man_anime_face_35mm_comic-185893.jpg!d"
//      ],
//      FirestoreManager.keyIsCosplayer: true,
//      FirestoreManager.keyIsPhotographer: true,
//      FirestoreManager.keyRarityBorder: 0,
//      FirestoreManager.keyRealName: "Bobby Jones",
//      FirestoreManager.keyDateRegistered: DateTime.now(),
//    }, merge: true);
    print("Finished creating mock user");
  }

  void setLoading() {
    //print("how many times is this called?");
    loggedInUser.updateWidgetsListeningToThis();
    setState(() {
      loadedUserData = true; // Stop showing spinner
    });
  }

  @override
  void dispose() {
    _navigationController.dispose();
    preloadPageController.dispose();
    super.dispose();
  }

  void moveToSelectedPage(int index) {
    setState(() {
      navIndex = index;
    });
    preloadPageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Widget renderLoadingIfNotLoaded() {
    if (loadedUserData) {
      return ChangeNotifierProvider<LoggedInUser>(
        builder: (context) => loggedInUser,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: Stack(children: <Widget>[
              pageView,
              Align(
                alignment: Alignment.bottomCenter,
                child: CircularBottomNavigation(
                  tabItems,
                  barHeight: kBottomNavHeight,
                  controller: _navigationController,
                  selectedCallback: (int selectedPos) {
                    moveToSelectedPage(selectedPos);
                  },
                ),
              )
            ]),
          ),
        ),
      );
    }
    return LoadingIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return renderLoadingIfNotLoaded();
  }
}
