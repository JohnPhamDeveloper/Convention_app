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
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';
import 'package:cosplay_app/widgets/pages/MessagePage.dart';
import 'package:cosplay_app/classes/Location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cosplay_app/widgets/MyAlertDialogue.dart';
import 'dart:async';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  LoggedInUser loggedInUser;
  LatLng loggedInUserLatLawdawdng;
  bool loadedUserData = false;
  PreloadPageController preloadPageController;
  CircularBottomNavigationController _navigationController;
  FirebaseUser firebaseUser;
  int navIndex = 0;
  PreloadPageView pageView;
  List<Map<dynamic, dynamic>> sortedUsersNearwdby = List<Map<dynamic, dynamic>>();
  Timer _updateLocationTimer;

  List<TabItem> tabItems = List.of([
    TabItem(Icons.home, "Home", Colors.pinkAccent),
    TabItem(Icons.search, "Search", Colors.pinkAccent),
    //TabItem(Icons.business_center, "Rewards", Colors.pinkAccent),
    TabItem(Icons.mail, "Message", Colors.pinkAccent),
    TabItem(Icons.notifications, "Alerts", Colors.pinkAccent),
    TabItem(Icons.person, "Profile", Colors.pinkAccent),
  ]);

  @override
  void initState() {
    super.initState();
    loggedInUser = LoggedInUser();
    preloadPageController = PreloadPageController(initialPage: navIndex);
    _navigationController = CircularBottomNavigationController(navIndex);
    _startMe();
  }

  _startMe() async {
    // Only login to _loginUser() and not the other (PHONE)
    //await _loginUser();
    await _loginUser();

    // Initial update
    LatLng newPos = await Location.getCurrentLocation();
    loggedInUser.setPosition(newPos);

    await _getUsersNearby();

    // Update user location and get everyone around every 30 seconds
    _updateLocationTimer = Timer.periodic(Duration(seconds: 30), (Timer t) async {
      print(
          "Updating user location to database... (PASSIVE 30 SECONDS) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      LatLng loggedInUserLatLng = await Location.getCurrentLocation();
      await Location.updateLocationToDatabase(loggedInUserLatLng, loggedInUser, firebaseUser.uid);
      await _getUsersNearby();
      print("Updating user location to database... (END) +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    });

    // END
    _setLoading(); // Remove loading screen and alert loggedInuserListener
    _createPages(); // Home, message, notif, etc...
  }

  _getUsersNearby() async {
    List<Map<dynamic, dynamic>> newUsersNearby = List<Map<dynamic, dynamic>>();
    final Map<dynamic, dynamic> response = await Location.getUsersNearby(loggedInUser.getPosition);
    List<dynamic> usersNearby = response['ids'];
    usersNearby = usersNearby.reversed.toList(); // Reverse to make it show nearby at top
    for (int i = 0; i < usersNearby.length; i++) {
      var uid;
      var distance;

      usersNearby[i].forEach((key, value) {
        uid = key;
        distance = value;
      });

      await Firestore.instance.collection('users').document(uid).get().then((snapshot) {
        Map<dynamic, dynamic> userData = Map<dynamic, dynamic>();
        String circleImageUrl = snapshot.data[FirestoreManager.keyPhotos][0];
        String displayName = snapshot.data[FirestoreManager.keyDisplayName];
        String seriesName = snapshot.data[FirestoreManager.keySeriesName];
        String cosplayName = snapshot.data[FirestoreManager.keyCosplayName];
        int friendliness = snapshot.data[FirestoreManager.keyFriendliness];
        int rarityBorder = snapshot.data[FirestoreManager.keyRarityBorder];
        bool isCosplayer = snapshot.data[FirestoreManager.keyIsCosplayer];
        bool isPhotographer = snapshot.data[FirestoreManager.keyIsPhotographer];
        int fame = snapshot.data[FirestoreManager.keyFame];
        DocumentSnapshot docSnapshot = snapshot;

        userData = {
          'circleImageUrl': circleImageUrl,
          'fame': fame,
          'displayName': displayName,
          'seriesName': seriesName,
          'cosplayName': cosplayName,
          'friendliness': friendliness,
          'rarityBorder': rarityBorder,
          'isCosplayer': isCosplayer,
          'isPhotographer': isPhotographer,
          'distance': distance,
          'snapshot': docSnapshot
        };

        newUsersNearby.add(userData);
      });
    }

    setState(() {
      loggedInUser.setUsersNearby(newUsersNearby);
      loggedInUser.updateListeners();
    });
  }

//  _loadAuthUser() async {
//    firebaseUser = await FirebaseAuth.instance.currentUser();
//  }

  // TODO REMOVE TEST
  _loginUser() async {
    //  print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob@hotmail.com', password: '123456').then((user) async {
      print("Successfully logged in");
      firebaseUser = await FirebaseAuth.instance.currentUser();
      loggedInUser.setFirebaseUser(firebaseUser);
      //_initAfterLoggedIn();
      if (firebaseUser != null) {
        // _initAfterLoggedIn();
        FirestoreManager.streamUserData(loggedInUser, user.uid);
      }
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  // TODO REMOVE TEST
  _loginUser2() async {
    // print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob2@hotmail.com', password: '123456').then((user) async {
      print("Successfully logged in");
      firebaseUser = await FirebaseAuth.instance.currentUser();
      loggedInUser.setFirebaseUser(firebaseUser);
      if (firebaseUser != null) {
        //   _initAfterLoggedIn();
        FirestoreManager.streamUserData(loggedInUser, user.uid);
      }
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  // TODO REMOVE TEST
  _loginUser3() async {
    // print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob3@hotmail.com', password: '123456').then((user) async {
      print("Successfully logged in");
      firebaseUser = await FirebaseAuth.instance.currentUser();
      loggedInUser.setFirebaseUser(firebaseUser);
      if (firebaseUser != null) {
        //   _initAfterLoggedIn();
        FirestoreManager.streamUserData(loggedInUser, user.uid);
      }
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  _loginUser4p() async {
    // print("FAKE LOGGING IN");
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: 'bob4@hotmail.com', password: '123456').then((user) async {
      print("Successfully logged in");
      firebaseUser = await FirebaseAuth.instance.currentUser();
      loggedInUser.setFirebaseUser(firebaseUser);

      if (firebaseUser != null) {
        //   _initAfterLoggedIn();
        FirestoreManager.streamUserData(loggedInUser, user.uid);
        // createSinglePhotographer();
      }
    }).catchError((error) {
      print('unable to login');
      print(error);
    });
  }

  _createPages() {
    pageView = PreloadPageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      preloadPagesCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      controller: preloadPageController,
      children: <Widget>[
        RankingListPage(),
        SearchPage(),
//        FamePage(),
        MessagePage(),
        NotificationPage(),
        ProfilePage(),
      ],
    );
  }

  void createSingleUser() async {
    await FirestoreManager.createUserInDatabase(
      documentName: "aaxXgxRl9BVe2zJcEomloI5yu0D3", // uid
      fame: 45,
      friendliness: 612,
      dateRegistered: Timestamp.now(),
      displayName: "Regardo The Fifth",
      photoUrls: ['https://c.pxhere.com/photos/fc/88/boy_portrait_people_man_anime_face_35mm_comic-185839.jpg!d'],
      cosplayName: "Naruto",
      seriesName: "NarutoSasuke",
      isCosplayer: true,
      isPhotographer: false,
      rarityBorder: 3,
      realName: "Bobby Jones", // Wont use this field
      cosplayerCost: "\$52.00/hr",
      photographerCost: "\$42.00/hr",
      photographyMonthsExperience: 2,
      photographyYearsExperience: 5,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );
  }

  void createSinglePhotographer() async {
    await FirestoreManager.createUserInDatabase(
      documentName: "fLQJKWSZwBVFqF12uppRnKQEZb82", // uid
      fame: 82,
      friendliness: 312,
      dateRegistered: Timestamp.now(),
      displayName: "Takano",
      photoUrls: ['https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d'],
      cosplayName: "Shouldnt show",
      seriesName: "SHouldnt show",
      isCosplayer: false,
      isPhotographer: true,
      rarityBorder: 2,
      realName: "Bobby Jones", // Wont use this field
      cosplayerCost: "\$52.00/hr",
      photographerCost: "\$800.00/hr",
      photographyMonthsExperience: 0,
      photographyYearsExperience: 0,
      cosplayMonthsExperience: 0,
      cosplayYearsExperience: 0,
    );
    final loc = await Location.getCurrentLocation();
    await Location.updateLocationToDatabase(loc, loggedInUser, firebaseUser.uid);
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
    // print("Finished creating mock user");
  }

  _setLoading() {
    loggedInUser.updateListeners();
    setState(() {
      loadedUserData = true; // Stop showing spinner
    });
  }

  @override
  void dispose() {
    _updateLocationTimer.cancel();
    _navigationController.dispose();
    preloadPageController.dispose();
    super.dispose();
  }

  moveToSelectedPage(int index) {
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
              // pageView,
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
              ),
              FlatButton(
                onPressed: () {
                  Fluttertoast.showToast(
                      msg: "Someone voted you as friendly!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.pinkAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: Text("PRESSS ME"),
              ),
//              FlatButton(
//                onPressed: () {
//                  MyAlertDialogue.showDialogue(context);
//                },
//                child: Text("PRESSS ME ALERT"),
//              ),
              // Message dot
//              Positioned(
//                bottom: 33,
//                left: (MediaQuery.of(context).size.width / 1.667) - 33,
//                child: CircularBox(
//                  width: 13.0,
//                  height: 13.0,
//                  padding: EdgeInsets.all(0.0),
//                  backgroundColor: Colors.pinkAccent,
//                  child: Text(
//                    "",
//                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0),
//                  ),
//                ),
//              ),
//              // Notifc dot
//              Positioned(
//                bottom: 33,
//                left: (MediaQuery.of(context).size.width / 1.25) - 38,
//                child: CircularBox(
//                  width: 13.0,
//                  height: 13.0,
//                  padding: EdgeInsets.all(0.0),
//                  backgroundColor: Colors.pinkAccent,
//                  child: Text(
//                    "",
//                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0),
//                  ),
//                ),
//              ),
//              Align(
//                alignment: Alignment.topCenter,
//                child: CircularBoxClipped(
//                  padding: EdgeInsets.all(0.0),
//                  child: Container(
//                    color: Colors.transparent,
//                    height: 50.0,
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.end,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        InkWell(
//                          onTap: () {
//                            print("TEST");
//                          },
//                          // Message icon
//                          child: Stack(
//                            overflow: Overflow.visible,
//                            children: <Widget>[
//                              Icon(Icons.mail, size: 30.0, color: Colors.grey[500]),
//                              Positioned(
//                                right: -2,
//                                top: 0,
//                                child: CircularBox(
//                                  width: 10.0,
//                                  height: 10.0,
//                                  padding: EdgeInsets.all(0.0),
//                                  backgroundColor: Colors.pinkAccent,
//                                  child: Text(
//                                    "",
//                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 10.0),
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                        SizedBox(width: 20.0),
//                      ],
//                    ),
//                  ),
//                  bottomLeft: Radius.circular(0.0),
//                  bottomRight: Radius.circular(0.0),
//                ),
//              ),
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
