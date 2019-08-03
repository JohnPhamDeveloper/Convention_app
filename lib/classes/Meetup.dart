import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/CloudFunction.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';

// Contains logic for selfie meetup, business meetup, and hangout meetups
class Meetup {
  static Future<HttpsCallableResult> sendSelfieRequestTo(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.sendSelfieRequest, key: 'otherUserUid', value: otherUserData.documentID);
  }

  static Future<HttpsCallableResult> acceptSelfieFrom(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.acceptButtonVerify, key: 'otherUserUid', value: otherUserData.documentID);
  }

  static Future<HttpsCallableResult> getSelfieMatchedLocation() {
    return CloudFunction.call(CloudFunction.getSelfieMatchedLocation);
  }

  static Future<HttpsCallableResult> checkIfOtherUserSentSelfieRequest(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.checkIfOtherUserSentSelfieRequest,
        key: 'otherUserUid', value: otherUserData.documentID);
  }
}
