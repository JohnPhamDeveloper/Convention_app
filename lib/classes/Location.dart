import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/Meetup.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  static updateLocationToDatabase(LatLng loggedInUserLatLng, LoggedInUser loggedInUser, String loggedInUserUid) async {
    final Geoflutterfire geo = Geoflutterfire();
    GeoFirePoint newGeoPoint = geo.point(latitude: loggedInUserLatLng.latitude, longitude: loggedInUserLatLng.longitude);
    String g = newGeoPoint.hash;
    GeoPoint l = newGeoPoint.geoPoint;

    print("Updating locations...");
    // Update the database with the logged in user's new position & displayName
    Firestore.instance.collection("locations").document(loggedInUserUid).setData({
      FirestoreManager.keyDisplayName: loggedInUser.getHashMap[FirestoreManager.keyDisplayName],
      FirestoreManager.keyPosition: newGeoPoint.data,
      'g': g,
      'l': l
    }, merge: true).catchError((error) {
      print("Firemap: Failed to update logged in users position");
    });
  }

  static getUsersNearby(LatLng loggedInUserLatLng) async {
    // For cloud (g: hash, l: geopoint, d: (documentData)
    // String g = newGeoPoint.hash;
    //GeoPoint l = newGeoPoint.geoPoint;

    // TODO MOVE APPROPIATELY TO PARENT
    // This is for the cloud functions to get everyone around the user
    // TODO so the user actually needs to poll their information maybe every 5 minutes or so? in order to see other users...
    Map<dynamic, dynamic> userLocation = Map<dynamic, dynamic>();
    userLocation['lat'] = loggedInUserLatLng.latitude;
    userLocation['lng'] = loggedInUserLatLng.longitude;
    final response = await Meetup.getEveryoneAround(userLocation);
    print("Get everyone arround: ${response.data['ids']}");
  }

  static Future<LatLng> getCurrentLocation() async {
    Position location = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((error) {
      print(error);
    });
    double lat = location.latitude;
    double lng = location.longitude;
    final latlng = LatLng(lat, lng);

    return latlng;
  }
}
