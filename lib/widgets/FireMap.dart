import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:rxdart/rxdart.dart';
import 'package:location/location.dart';
import 'dart:async';

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

  _startQuery() async {
    var pos = await location.getLocation();
    double lat = pos.latitude;
    double lng = pos.longitude;

    var ref = firestore.collection('locations');
    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);

    // whenever radius changes, go to our database and find all
    // documents that are within the radius using the user's center position
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
            center: center,
            radius: rad,
            field: 'position',
            strictMode: true,
          );
    }).listen(_updateMarkers);
  }

  // Update query based on slider value
  _updateQuery(double value) {
    setState(() {
      radius.add(value);
    });
  }

  // All documents within the radius of the users will be displayed
  // on the user's map
  void _updateMarkers(List<DocumentSnapshot> documentList) {
    print(documentList);

    markers.clear();

    documentList.forEach((snapshot) {
      GeoPoint pos = snapshot.data['position']['geopoint'];
      double distance = snapshot.data['distance'];
      final MarkerId markerId = MarkerId(UniqueKey().toString());

      var marker = Marker(
        markerId: markerId,
        position: LatLng(pos.latitude, pos.longitude),
        icon: otherUserIconOnMap,
        infoWindow: InfoWindow(
          title: "Magic Marker",
          snippet: "$distance test",
        ),
      );

      markers[markerId] = marker;
    });
  }

  // Why does this return?
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
    otherUserIconOnMap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(20, 20)), "assets/greendot.png");
  }

  @override
  void initState() {
    super.initState();
    _startQuery();
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
            label: 'Radius ${radius.value}km',
            activeColor: Colors.cyan[300],
            inactiveColor: Colors.cyan[300].withOpacity(0.2),
            onChanged: _updateQuery,
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: InkWell(
            onTap: _addGeoPoint,
            child: Icon(Icons.my_location, size: 30),
          ),
        ),
      ],
    );
  }
}
