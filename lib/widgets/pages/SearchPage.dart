import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/TopNavBarWithLines.dart';
import 'package:cosplay_app/widgets/SearchSectionItem.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cosplay_app/widgets/FireMap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cosplay_app/widgets/ChipNavigator.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  LoggedInUser loggedInUser;
  PageController pageController;
  PageView pageView;
  List<Map<dynamic, dynamic>> cosplayersNearby = List<Map<dynamic, dynamic>>();
  List<Map<dynamic, dynamic>> photographersNearby = List<Map<dynamic, dynamic>>();

  bool loadedUsers = false;
  int navIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //_loginUser();

    _checkPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggedInUser = Provider.of<LoggedInUser>(context);
    _initUsers();
  }

  _initUsers() async {
    cosplayersNearby.clear();
    photographersNearby.clear();
    for (int i = 0; i < loggedInUser.getUsersNearby.length; i++) {
      if (loggedInUser.getUsersNearby[i]['isCosplayer'])
        cosplayersNearby.add(loggedInUser.getUsersNearby[i]);
      else if (loggedInUser.getUsersNearby[i]['isPhotographer']) photographersNearby.add(loggedInUser.getUsersNearby[i]);
      //TODO need congoer section
    }

    _createPages();

    //TODO Delete not needed since main page does the loading...?
    setState(() {
      loadedUsers = true;
    });
  }

  _createPages() {
    pageController = PageController(initialPage: navIndex);
    pageView = PageView(
      onPageChanged: (index) {
        setState(() {
          navIndex = index;
        });
      },
      controller: pageController,
      children: <Widget>[
        SearchSection(
          usersNearby: cosplayersNearby,
          firebaseUser: loggedInUser.getFirebaseUser,
          loggedInUserLatLng: loggedInUser.getPosition,
        ),
        SearchSection(
          usersNearby: photographersNearby,
          firebaseUser: loggedInUser.getFirebaseUser,
          loggedInUserLatLng: loggedInUser.getPosition,
        ),
        //TODO congoer section
      ],
    );
  }

  _checkPermission() async {
    print("Trying to ask for permission...");
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.locationAlways);
    if (permission == PermissionStatus.disabled ||
        permission == PermissionStatus.unknown ||
        permission == PermissionStatus.disabled) {
      print("-------LOCATION DISABLED-----------");
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler().requestPermissions([PermissionGroup.location]);
    } else {
      print("Permisson already granted");
    }
  }

  Widget _renderPages() {
    if (loadedUsers) {
      return Expanded(child: pageView);
    } else {
      return Text("loading...");
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: FireMap(loggedInUserAuth: loggedInUser.getFirebaseUser),
        ),
        Flexible(
          flex: 3,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  ChipNavigator(
                    chipNames: <String>['Cosplayers', 'Photographers', 'Con-goers'],
                    onPressed: (index) {
                      pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    navIndex: navIndex,
                  ),
                  SizedBox(height: 6.0),
                  _renderPages()
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// SEARCH SECTION ITEM ----------------- BREAK INTO NEW FILE
//
//
//
//
//
//
//
//

//class PhotographerSearchSection extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(
//      itemCount: photo
//      itemBuilder: (context, index) {
//        return cosplayerSearchInfoWidgets[index];
//      },
//    );
////    return ListView(
////      children: <Widget>[
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 12,
//////          monthsExperience: 2,
//////          backgroundImage:
//////              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d",
//////          friendliness: 324,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Resano Bobs",
//////          yearsExperience: 1,
//////          monthsExperience: 2,
//////          cost: "Can Negotiate",
//////          backgroundImage:
//////              "https://c.pxhere.com/images/c7/21/c8e22db330eb09e78970ac8b2ce2-1456325.jpg!d",
//////          friendliness: 153,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 2,
//////          monthsExperience: 3,
//////          cost: "\$52.12 / hr",
//////          backgroundImage:
//////              "https://c.pxhere.com/images/52/27/c8e31718a7e13b915f72689e7911-1424101.jpg!d",
//////          friendliness: 45,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Bob Smith",
//////          yearsExperience: 4,
//////          monthsExperience: 6,
//////          cost: "\$92.12 / session",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/9d/fd/photographer_camera_photo_photos_foto_lens_take_a_photograph_electronic_equipment-942701.jpg!d",
//////          friendliness: 32,
//////        ),
//////        PhotographerSearchInfo(
//////          name: ""
//////              "Nunjo Saert",
//////          yearsExperience: 8,
//////          monthsExperience: 1,
//////          cost: "Not Shooting",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/b3/2d/camera_digital_equipment_female_girl_isolated_lens_people-1260617.jpg!d",
//////          friendliness: 74,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Teer San",
//////          yearsExperience: 3,
//////          monthsExperience: 3,
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/08/97/photographer_road_camera_girl_person-180399.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Loon Poi",
//////          yearsExperience: 8,
//////          monthsExperience: 4,
//////          cost: "\$15.00 / hr",
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/62/c1/camera_photographer_person_photography_urban-133163.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Erri Wan",
//////          yearsExperience: 1,
//////          monthsExperience: 3,
//////          backgroundImage:
//////              "https://c.pxhere.com/photos/64/b4/photographer_photography_digital_camera_dslr_camera_digital_single_lens_reflex_camera_camera-964918.jpg!d",
//////          friendliness: 99,
//////        ),
//////        PhotographerSearchInfo(
//////          name: "Ettai Gonchat",
//////          yearsExperience: 12,
//////          monthsExperience: 2,
//////          backgroundImage:
//////              "https://c.pxhere.com/images/29/3a/ab7eb8106f292a24d2a5d818c6a1-1418380.jpg!d",
//////          friendliness: 1532,
//////        ),
//////        SizedBox(height: 90.0),
////      ],
////    );
//  }
//}
