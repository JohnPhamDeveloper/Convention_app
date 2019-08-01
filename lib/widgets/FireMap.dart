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

/// Structure:
/// 1) _startQuery()
/// Gets user location and center point and subscribe to radius which
/// user can change with the slider. Then go to database and only find
/// documents around that radius. Calls _updateMarker() everytime radius changes.
///
/// 2) _updateMarkers()
/// Clear all markers from screen. Then go through each document around
/// the radius of the user and create a marker using the documents position.
/// Add that marker to the "markers" state and it'll display onto map
///
/// 3) _updateQuery()
/// Called on the slider's onChange.
/// Whenever the slider changes, it will setState the radius variable.
/// As a result, radius.switchMap will be called again and find all
/// documents around that new radius.

/// How to make it so loggedInUser gets the information of the "usersToShareLocationWIth" every 10 seconds?
/// 1) loggedInUser.getusersToSharelOcationsWith[i].getLocation
/// 2) where to create timer? What does this timer do? Get a reference to each usersToshareLocWith
/// 3) For each reference, get currentLocation in database
class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  LoggedInUser loggedInUser;
  Position position = Position();
  Timer _updateMapTimer;
//  Location location = Location();
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
    // _startQuery();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loggedInUser = LoggedInUser();
    loggedInUser = Provider.of<LoggedInUser>(context);

    // Listen to this value so we can stop or resume map update for selfie mode
    _isInSelfieMode = BehaviorSubject<bool>.seeded(loggedInUser.getHashMap[FirestoreManager.keyIsInSelfieMode]);
    _isInSelfieMode.listen((isInSelfieMode) {
      print('IS IN SELFIE MODE CHANGED IN FIREMAP BEHAVIORSUBJECT ---------------------- $isInSelfieMode');
      if (isInSelfieMode) {
        // Create timer only if it hasn't been created yet
        if (_updateMapTimer == null) {
          _startMapUpdateTimer();
        }
      } else {
        print("------------CANCELING MAP UPDATE TIMER-------------");
        // Not in selfie mode so cancel timer?
        // TODO since the user will have other reasons for updating map (such as business or hangout) this needs to change
        if (_updateMapTimer != null) {
          _updateMapTimer.cancel();
          _updateMapTimer = null;
        }
        print("------------CLEARING MARKERS DUE TO NOT BEING IN SELFIE MODE-------------");
        // TODO this should also change but we should have different icons for business and hangouts.
        // TODO otherwise selfie, business, and hangout can all run concurrently. Though they neeed a sbuscription (too much reads)
        setState(() {
          _markers.clear();
        });
      }
    });

    // Does anything need to rebuild when the user is in selfie mode? hmmmmm refer to TODO below
    //TODO If map ever cost money, then we can just only show the map when the user is in selfie mode
    // TODO aka use builder for loggedInuser consumer and unmount map if they aren't in selfie mode
  }

  _startMapUpdateTimer() {
    // Update map every 10 seconds
    _updateMapTimer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      // No longer in selfie mode so there's no reason to update the map
      if (!LoggedInUser.isInSelfieMode(loggedInUser)) {
        print("------------CANCEL MAP UPDATE SINCE OUT OF SELFIE MODE--------------");
        t.cancel();
      } else {
        print("-------------UPDATING MAP-------------");
        _createMarkersOnMap();
      }
    });
  }

  _createMarkersOnMap() {
    print("____________FIREMAP________ CREATING MARKERS....");
    // Contains reference to other users
    List<DocumentReference> usersToShareLocationWith = loggedInUser.getHashMap[FirestoreManager.keyUsersToShareLocationWith];

    // No one to share location with
    if (usersToShareLocationWith.length > 0) {
      // Go through each reference and get their geoposition
      for (int i = 0; i < usersToShareLocationWith.length; i++) {
        // Use the documentReferences and get their document ID. With the document ID, look up their location in the
        // Locations collection since locations documentNames are the users documentId
        // Create marker for each users position
        String userDocumentId = usersToShareLocationWith[i].documentID;

        // Interrupts
        if (_isInSelfieMode.value) return;

        // Get the user location from database
        Firestore.instance.collection("locations").document(userDocumentId).get().then((snapshot) async {
          FirestoreReadcheck.searchInfoPageReads++;
          FirestoreReadcheck.printSearchInfoPageReads();
          await _createMarkerUsingOtherUserInformation(snapshot);
        });

//        usersToShareLocationWith[i].get().then((snapshot) async {
//          await _createMarkerUsingOtherUserInformation(snapshot);
//          print('adding marker on map');
//        }).catchError((error) {
//          //TODO need to tell user it failed with a widget...
//          print("FireMap: Failed to get a user in usersToShareLocationWith");
//          print("The error is: $error");
//          return Future.error("FireMap: Failed to get a user in usersToShareLocationWith");
//        });
      }
    }
  }

  _createMarkerUsingOtherUserInformation(DocumentSnapshot snapshot) async {
    print("Printing other users position _+_+_+_+_+_+_+_");
    GeoPoint otherUserGeoPoint = snapshot.data['position']['geopoint'];
    String otherUserName = snapshot.data[FirestoreManager.keyDisplayName];
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((error) {
      print(error);
      return Future.error(error);
    });
    print("Position successfully ran (normla location bugs out)");
    // Location buggy, doesn't return
    //Location location = Location();
    //LocationData position = await location.getLocation();
    double distance = geo
        .point(latitude: otherUserGeoPoint.latitude, longitude: otherUserGeoPoint.longitude)
        .distance(lat: position.latitude, lng: position.longitude);
    final MarkerId markerId = MarkerId(UniqueKey().toString());

    // Create marker at that position
    Marker marker = Marker(
      markerId: markerId,
      position: LatLng(otherUserGeoPoint.latitude, otherUserGeoPoint.longitude),
      icon: otherUserIconOnMap,
      //icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: '$otherUserName',
        snippet: "$distance km ${distance / 1.609} miles",
      ),
    );

    // Interrupts
    // TODO another way is to periodically check if they are in selfie mode  and just clear markers?
    if (_isInSelfieMode.value) {
      print("====================INTERRUPTED SET STATE MARKER=====================");
    } else {
      setState(() {
        print("Updating the marker which should update the map");
        _markers[markerId] = marker;
      });
    }
  }

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

  void _updateMarkers(List<DocumentSnapshot> documentListWithinRadius) {
    print("Updating markers on screen...");
    print(documentListWithinRadius);

    _markers.clear();

    // Go through every document in our locations collection
    documentListWithinRadius.forEach((snapshot) {
      // Get position of that document
      GeoPoint pos = snapshot.data['position']['geopoint'];
      double distance = snapshot.data['distance'];
      final MarkerId markerId = MarkerId(UniqueKey().toString());

      // Create marker at that position
      var marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: otherUserIconOnMap,
        //icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: "Magic Marker",
          snippet: "$distance km",
        ),
      );
      setState(() {
        _markers[markerId] = marker;
      });
    });
  }

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
    print(pos);
    setState(() {
      _lastTap = pos;
      _addMarker(pos);
    });
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
