import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
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

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location location = Location();
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  BitmapDescriptor otherUserIconOnMap;
  LatLng _lastTap;
  StreamSubscription subscription;

  // Stateful
  BehaviorSubject<double> radius = BehaviorSubject<double>.seeded(1.0);
  Stream<Query> query;

  @override
  void initState() {
    super.initState();
    _initOtherUserIcon();
    _startQuery();
  }

  _startQuery() async {
    print("Starting query...");
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    var ref = firestore.collection('locations');
    print("Getting reference to location in firestore... $ref");

    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // whenever radius changes, go to our database and find all
    // documents that are within the radius using the user's center position
    subscription = radius.switchMap((rad) {
      print("Mapping through ${rad / 1.609} miles");
      return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad / 1.609, // Convert KM to MILES
            field: 'position',
            strictMode: true,
          );
    }).listen(_updateMarkers); // pass in documentSnapshot
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print("Updating markers on screen...");
    print(documentList);

    markers.clear();

    // Go through every document in our locations collection
    documentList.forEach((snapshot) {
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

      markers[markerId] = marker;
    });
  }

  // Update query based on slider value
  _updateQuery(double value) {
    print("Updating query...");
    setState(() {
      radius.add(value);
    });
  }

  Future<DocumentReference> _addGeoPoint() async {
    // Get current user position
    var pos = await location.getLocation();

    // Create a geopoint that will be stored in firebase
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);

    // Add user current position to firebase
    return firestore.collection("locations").add({
      'position': point.data,
      'name': "hello!",
    });
  }

  Future<DocumentReference> _addGeoPointAt(double lat, double long) async {
    // Create a geopoint that will be stored in firebase
    GeoFirePoint point = geo.point(latitude: lat, longitude: long);

    // Add user current position to firebase
    return firestore.collection("locations").add({
      'position': point.data,
      'name': "hello!NEW",
    });
  }

  // Get last position tapped onto the map
  _onTap(LatLng pos) {
    print(pos);
    setState(() {
      _lastTap = pos;
      _addMarker(pos);
    });
  }

  _onMapCreated(GoogleMapController mapController) {
    this.mapController = mapController;
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
      markers[markerId] = marker;
    });
  }

  _initOtherUserIcon() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(0.0000000001, 0.000000001)),
            'assets/greendot.png')
        .then((onValue) {
      otherUserIconOnMap = onValue;
    });

//    otherUserIconOnMap = await BitmapDescriptor.fromAssetImage(
//        ImageConfiguration(size: Size(0.005, 0.005)), "assets/greendot.png");
  }

  @override
  void dispose() {
    radius.close();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          markers: Set<Marker>.of(markers.values),
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
            divisions: 5,
            value: radius.value,
            label: 'Radius ${radius.value}km?',
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
              _addGeoPointAt(37.315616, -121.831424);
            },
            child: Icon(Icons.my_location, size: 30),
          ),
        ),
      ],
    );
  }
}
