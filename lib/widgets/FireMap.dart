import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:rxdart/rxdart.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
//import 'package:location/location.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cosplay_app/classes/Meetup.dart';
import 'package:cosplay_app/classes/Location.dart';

class FireMap extends StatefulWidget {
  FirebaseUser loggedInUserAuth;

  FireMap({@required this.loggedInUserAuth});

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  LoggedInUser loggedInUser = LoggedInUser();
  Position position = Position();
  Timer _updateMapTimer;
  bool isMatched = false;
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  BitmapDescriptor otherUserIconOnMap;
  LatLng _lastTap;
  StreamSubscription subscription;

  // Stateful
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(1.0);
  BehaviorSubject<bool> _isInSelfieMode;
  Stream<Query> query;

  @override
  void initState() {
    super.initState();
    _initOtherUserIcon(); // Other user icons on the map (green dot)
    _startListenToMatchedUsers();
  }

  void _startListenToMatchedUsers() async {
    Firestore.instance.collection('selfie').document(widget.loggedInUserAuth.uid).snapshots().listen((snapshot) {
      print("RE--------------------------------------------------------------------");
      if (snapshot.data[FirestoreManager.keyMatchedUsers] != null) {
        //TODO WARNING: IF A MAP BECOMES EMPTY, IT TURNS INTO AN ARRAY IN FIRESTORE. isEmpty covers both "Array" and "Map" type
        if (snapshot.data[FirestoreManager.keyMatchedUsers].isEmpty) {
          print("STOP TIMER");
          isMatched = false;
          _stopMapUpdate();
        } else {
          print("ATTEMPING TO START TIMER");
          isMatched = true;
          _startMapUpdateTimer();
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggedInUser = Provider.of<LoggedInUser>(context);
  }

  _startMapUpdateTimer() {
    // Update map every 10 seconds
    _updateMapTimer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      if (!isMatched) {
        print("Timer stopped due to no matches...");
        t.cancel();
      }
      _markers.clear();
      print("Timer to update location AND match locations every 10 seconds is running....");
      LatLng loggedInUserLatLng = await Location.getCurrentLocation();
      Location.updateLocationToDatabase(loggedInUserLatLng, loggedInUser, widget.loggedInUserAuth.uid);
      _updateMatchedUsersOnMap(loggedInUserLatLng);
    });
  }

  _updateMatchedUsersOnMap(LatLng loggedInUserLatLng) async {
    await Meetup.getSelfieMatchedLocation().then((response) async {
      // Create a marker for every matched user on the map
      for (dynamic matchedUserLocationData in response.data) {
        String displayName = matchedUserLocationData['displayName'];
        double latitude = matchedUserLocationData['position']['_latitude'];
        double longitude = matchedUserLocationData['position']['_longitude'];
        LatLng otherUserLatLng = LatLng(latitude, longitude);

        _createMarker(loggedInUserLatLng, otherUserLatLng, displayName);
      }
    }).catchError((error) {
      print(error.toString());
      print("Meetup.getSelfieMatchedLocation failed to execute (probably due to having no matches)");
    });
  }

  _stopMapUpdate() {
    if (_updateMapTimer != null) {
      _updateMapTimer.cancel();
      _updateMapTimer = null;
    }

    setState(() {
      _markers.clear();
    });
  }

  _createMarker(LatLng currentUser, LatLng otherUser, String displayName) {
    // Distance between the two users
    double distanceInKm = geo
        .point(latitude: otherUser.latitude, longitude: otherUser.longitude) //  Other user
        .distance(lat: currentUser.latitude, lng: currentUser.longitude); // Current user\

    double distanceInMiles = distanceInKm / 1.609;

    final MarkerId markerId = MarkerId(UniqueKey().toString());
    // Create marker at that position
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(otherUser.latitude, otherUser.longitude),
      icon: otherUserIconOnMap,
      infoWindow: InfoWindow(
        title: '$displayName',
        snippet: "${distanceInMiles.toStringAsFixed(1)} miles",
      ),
    );

    setState(() {
      print("Updating the marker which should update the map");
      _markers[markerId] = marker;
    });
  }

//  _updateLocationToDatabase(LatLng loggedInUserLatLng) async {
//    final Geoflutterfire geo = Geoflutterfire();
//    GeoFirePoint newGeoPoint = geo.point(latitude: loggedInUserLatLng.latitude, longitude: loggedInUserLatLng.longitude);
//
//    // For cloud (g: hash, l: geopoint, d: (documentData)
//    String g = newGeoPoint.hash;
//    GeoPoint l = newGeoPoint.geoPoint;
//
//    // TODO MOVE APPROPIATELY TO PARENT
//    // This is for the cloud functions to get everyone around the user
//    // TODO so the user actually needs to poll their information maybe every 5 minutes or so? in order to see other users...
//    Map<dynamic, dynamic> userLocation = Map<dynamic, dynamic>();
//    userLocation['lat'] = l.latitude;
//    userLocation['lng'] = l.longitude;
//    final response = await Meetup.getEveryoneAround(userLocation);
//    print("Get everyone arround: ${response.data['ids']}");
//
//    print("Updating locations...");
//    // Update the database with the logged in user's new position & displayName
//    Firestore.instance.collection("locations").document(loggedInUserAuth.uid).setData({
//      FirestoreManager.keyDisplayName: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
//      FirestoreManager.keyPosition: newGeoPoint.data,
//      'g': g,
//      'l': l
//    }, merge: true).catchError((error) {
//      print("Firemap: Failed to update logged in users position");
//    });
//  }

//  Future<LatLng> _getCurrentLocation() async {
//    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((error) {
//      print(error);
//    });
//    double lat = location.latitude;
//    double lng = location.longitude;
//    final latlng = LatLng(lat, lng);
//
//    return latlng;
//  }

  // TODO not needed
//  _createMarkersOnMap() {
//    print("____________FIREMAP________ CREATING MARKERS....");
//
//    //
//
//    // Contains reference to other users
//    List<DocumentReference> usersToShareLocationWith = loggedInUser.getHashMap[FirestoreManager.keyUsersToShareLocationWith];
//
//    // No one to share location with
//    if (usersToShareLocationWith.length > 0) {
//      // Go through each reference and get their geoposition
//      for (int i = 0; i < usersToShareLocationWith.length; i++) {
//        // Use the documentReferences and get their document ID. With the document ID, look up their location in the
//        // Locations collection since locations documentNames are the users documentId
//        // Create marker for each users position
//        String userDocumentId = usersToShareLocationWith[i].documentID;
//
//        // Interrupts
//        if (!_isInSelfieMode.value) return;
//
//        // Get the user location from database
//        Firestore.instance.collection("locations").document(userDocumentId).get().then((snapshot) async {
//          FirestoreReadcheck.searchInfoPageReads++;
//          FirestoreReadcheck.printSearchInfoPageReads();
//          await _createMarkerUsingOtherUserInformation(snapshot);
//        });
//
////        usersToShareLocationWith[i].get().then((snapshot) async {
////          await _createMarkerUsingOtherUserInformation(snapshot);
////          print('adding marker on map');
////        }).catchError((error) {
////          //TODO need to tell user it failed with a widget...
////          print("FireMap: Failed to get a user in usersToShareLocationWith");
////          print("The error is: $error");
////          return Future.error("FireMap: Failed to get a user in usersToShareLocationWith");
////        });
//      }
//    }
//  }
//
//
  //TODO not needed
//  _createMarkerUsingOtherUserInformation(DocumentSnapshot snapshot) async {
//    print("Printing other users position _+_+_+_+_+_+_+_");
//    GeoPoint otherUserGeoPoint = snapshot.data['position']['geopoint'];
//    String otherUserName = snapshot.data[FirestoreManager.keyDisplayName];
//    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((error) {
//      print(error);
//      return Future.error(error);
//    });
//    print("Position successfully ran (normla location bugs out)");
//    // Location buggy, doesn't return
//    //Location location = Location();
//    //LocationData position = await location.getLocation();
//    double distance = geo
//        .point(latitude: otherUserGeoPoint.latitude, longitude: otherUserGeoPoint.longitude)
//        .distance(lat: position.latitude, lng: position.longitude);
//    final MarkerId markerId = MarkerId(UniqueKey().toString());
//
//    // Create marker at that position
//    Marker marker = Marker(
//      markerId: markerId,
//      position: LatLng(otherUserGeoPoint.latitude, otherUserGeoPoint.longitude),
//      icon: otherUserIconOnMap,
//      //icon: BitmapDescriptor.defaultMarker,
//      infoWindow: InfoWindow(
//        title: '$otherUserName',
//        snippet: "$distance km ${distance / 1.609} miles",
//      ),
//    );
//
//    // Interrupts
//    // TODO another way is to periodically check if they are in selfie mode  and just clear markers?
//    if (!_isInSelfieMode.value) {
//      print("====================INTERRUPTED SET STATE MARKER=====================");
//    } else {
//      setState(() {
//        print("Updating the marker which should update the map");
//        _markers[markerId] = marker;
//      });
//    }
//  }

  _startQuery() async {
//    print("Starting query...");
//    var pos = await location.getLocation();
//    double lat = pos.latitude;
//    double lng = pos.longitude;
//
//    var ref = firestore.collection('locations');
//    print("Getting reference to location in firestore... $ref");
//
//    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // whenever radius changes, go to our database and find all
    // documents that are within the radius using the user's center position
//    subscription = radius.switchMap((rad) {
//      print("Mapping through ${rad} km");
//      return geo.collection(collectionRef: ref).within(
//            center: center,
//            radius: rad, // Convert KM to MILES
//            field: 'position',
//            strictMode: true,
//          );
//    }).listen(_updateMarkers); // pass in documentSnapshot

    /// Clicking accept selfie triggers the GPS to start polling location data
    /// Each device will now begin updating their current position every 10 seconds to the firestore
    /// // Get current user position
    //    var pos = await location.getLocation();
    //
    //    // Create a geopoint that will be stored in firebase
    //    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    //
    //    // Add user current position to firebase
    //    return firestore.collection("locations").update({
    //      'position': point.data,
    //      'name': "hello!",
    //    });
    ///

    // TODO Poll user position every 10 seconds
//    StreamSubscription selfieSubscription =
//        geo.collection(collectionRef: ref).within(center: null, radius: null, field: null).listen(onData);
//    selfieSubscription.cancel();
  }

//  void _updateMarkers(List<DocumentSnapshot> documentListWithinRadius) {
//    print("Updating markers on screen...");
//    print(documentListWithinRadius);
//
//    _markers.clear();
//
//    // Go through every document in our locations collection
//    documentListWithinRadius.forEach((snapshot) {
//      // Get position of that document
//      GeoPoint pos = snapshot.data['position']['geopoint'];
//      double distance = snapshot.data['distance'];
//      final MarkerId markerId = MarkerId(UniqueKey().toString());
//
//      // Create marker at that position
//      var marker = Marker(
//        markerId: markerId,
//        position: LatLng(pos.latitude, pos.longitude),
//        icon: otherUserIconOnMap,
//        //icon: BitmapDescriptor.defaultMarker,
//        infoWindow: InfoWindow(
//          title: "Magic Marker",
//          snippet: "$distance km",
//        ),
//      );
//      setState(() {
//        _markers[markerId] = marker;
//      });
//    });
//  }

  // Update query based on slider value
  _updateQuery(double value) {
//    print("Updating query...");
//    setState(() {
//      radius.add(value);
//    });
  }

//  Future<DocumentReference> _addGeoPoint() async {
//    // Get current user position
//    var pos = await location.getLocation();
//
//    // Create a geopoint that will be stored in firebase
//    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
//
//    // Add user current position to firebase
//    return firestore.collection("locations").add({
//      'position': point.data,
//      'name': "hello!",
//    });
//  }

//  Future<DocumentReference> _addGeoPointAt(double lat, double long) async {
//    // Create a geopoint that will be stored in firebase
//    GeoFirePoint point = geo.point(latitude: lat, longitude: long);
//
//    // Add user current position to firebase
//    return firestore.collection("locations").add({
//      'position': point.data,
//      'name': "hello!NEW",
//    });
//  }

  // Get last position tapped onto the map
  _onTap(LatLng pos) {
//    print(pos);
//    setState(() {
//      _lastTap = pos;
//      _addMarker(pos);
//    });
  }

  _onMapCreated(GoogleMapController mapController) {
    this._mapController = mapController;
  }

//  _animateToUser() async {
//    LocationData data = await location.getLocation();
//    mapController.animateCamera(
//      CameraUpdate.newCameraPosition(
//        CameraPosition(
//          target: LatLng(data.latitude, data.longitude),
//          zoom: 17.0,
//        ),
//      ),
//    );
//  }

  _addMarker(LatLng pos) {
    final MarkerId markerId = MarkerId(UniqueKey().toString());
    var marker = Marker(
      position: pos,
      markerId: markerId,
      infoWindow: InfoWindow(title: "Naruto Gathering"),
    );

    setState(() {
      _markers[markerId] = marker;
    });
  }

  _initOtherUserIcon() async {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(0.0000000001, 0.000000001)), 'assets/greendot.png')
        .then((onValue) {
      otherUserIconOnMap = onValue;
    });

//    otherUserIconOnMap = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(size: Size(0.005, 0.005)), "assets/greendot.png");
  }

  @override
  void dispose() {
    if (radius != null) radius.close();
    if (_isInSelfieMode != null) _isInSelfieMode.close();
    if (subscription != null) subscription.cancel();
    if (_updateMapTimer != null) _updateMapTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          markers: Set<Marker>.of(_markers.values),
          onTap: _onTap,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.3289618, -121.8895222),
            zoom: 12.0,
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: radius.value,
            label: 'Radius ${radius.value} km',
            activeColor: Colors.cyan[300],
            inactiveColor: Colors.cyan[300].withOpacity(0.2),
            onChanged: _updateQuery,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: InkWell(
            onTap: () {
//              _addGeoPointAt(37.315616, -121.831424);
            },
            child: Icon(Icons.my_location, size: 30),
          ),
        ),
      ],
    );
  }
}
