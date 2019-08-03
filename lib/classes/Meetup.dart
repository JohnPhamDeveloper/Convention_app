import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/CloudFunction.dart';

// Contains logic for selfie meetup, business meetup, and hangout meetups
class Meetup {
  static Future<HttpsCallableResult> sendSelfieRequestTo(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.sendSelfieRequest, 'otherUserUid', otherUserData.documentID);
  }

  static Future<HttpsCallableResult> acceptSelfieFrom(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.acceptButtonVerify, 'otherUserUid', otherUserData.documentID);
  }

  static Future<HttpsCallableResult> checkIfOtherUserSentSelfieRequest(DocumentSnapshot otherUserData) {
    return CloudFunction.call(CloudFunction.checkIfOtherUserSentSelfieRequest, 'otherUserUid', otherUserData.documentID);
  }
}
