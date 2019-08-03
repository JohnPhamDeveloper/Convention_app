import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HeroProfileStart.dart';
import 'package:cosplay_app/widgets/HeroProfileDetails.dart';
import 'package:cosplay_app/widgets/HeroProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:provider/provider.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cosplay_app/classes/FirestoreReadcheck.dart';
import 'package:cosplay_app/classes/Meetup.dart';

// Used for creating the hero widgets to show the selected user's profile
// into view
class HeroCreator {
  // Creates the two pages
  // Start is the first page and Details is the second page
  static HeroProfileStart createHeroProfileStart(
      String dotHeroName, String imageHeroName, DocumentSnapshot data, LoggedInUser currentLoggedInUser) {
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, data);

    return HeroProfileStart(
      isLoggedInUser: isLookingAtOwnProfile,
      heroName: dotHeroName,
      imageHeroName: imageHeroName,
      userImages: data[FirestoreManager.keyPhotos],
      name: data[FirestoreManager.keyDisplayName],
      friendliness: data[FirestoreManager.keyFriendliness],
      fame: data[FirestoreManager.keyFame],
      bottomLeftItemPadding: EdgeInsets.only(left: 20, bottom: 25),
    );
  }

  static _checkIfOtherUserSentSelfieRequest(DocumentSnapshot otherUserDocumentSnapshot) async {
    print("STARTING CALL FOR FUNC -(*@&*@&*@&&*");
    final response = await Meetup.checkIfOtherUserSentSelfieRequest(otherUserDocumentSnapshot);
    print("PRINTING DATA ^^^^^^^^^^^^^^^^^^^^^^^^^");
    print(response.data);
  }

  static _checkIfLoggedInUserSentSelfieRequest(DocumentSnapshot otherUserDocumentSnapshot) async {
    print("STARTING CALL FOR FUNC -(*@&*@&*@&&*");
    final response = await Meetup.checkIfOtherUserSentSelfieRequest(otherUserDocumentSnapshot);
    print("PRINTING DATA ^^^^^^^^^^^^^^^^^^^^^^^^^");
    print(response.data);
  }

  static HeroProfileDetails createHeroProfileDetails(
      DocumentSnapshot otherUserDocumentSnapshot, BuildContext context, LoggedInUser currentLoggedInUser) {
    // Build a profile with different buttons if they're looking at themselves
    bool isLookingAtOwnProfile = _checkSame(currentLoggedInUser, otherUserDocumentSnapshot);

    // TODO this logic shouldn't be done locally also incomgin and outgoing request should be private
    // TODO exept to the orignal user
    //bool isOtherUserInCurrentUserIncomingSelfieRequestList = false;
    // bool isOtherUserInCurrentUserOutgoingSelfieRequestList = false;

    bool displayRequestButton = false;
    bool displayAcceptButton = false;
    bool displayFinishButton = false;

    // Get logged in users incoming and outgoing selfie requests
    List<dynamic> loggedInUserIncomingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];
    List<dynamic> loggedInUserOutgoingSelfieReferences =
        currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];

    // ??
//    if (!isLookingAtOwnProfile) {
//      _checkIfOtherUserSentSelfieRequest(otherUserDocumentSnapshot);
//      // TODO record malicious attempt to request selfie to itself
//    }

    // If current user sent and recieved a selfie request from other user
    if (loggedInUserIncomingSelfieReferences.contains(otherUserDocumentSnapshot.documentID) &&
        loggedInUserOutgoingSelfieReferences.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user received and sent selfie request from other user");
      displayFinishButton = true;
    }

    // Display accept button if the other person exists in logged in user incoming list
    // If current user received a selfie request from other user
    else if (loggedInUserIncomingSelfieReferences.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user received selfie request from other user");
      displayAcceptButton = true;
    }
    // If current user didnt recieve or send selfie request to the other user
    else if (loggedInUserOutgoingSelfieReferences.contains(otherUserDocumentSnapshot.documentID)) {
      print("Current user didnt send or receive selfie from other user");
      displayRequestButton = true;
    }

    // TODO record mark user as malicious if they try to modify client code

    // It should check if the current user exists in
    // 1) The other user's incoming request list (current user sent request)
    // 2) The other user's outgoing request list (other user sen request)
    // 3) The current user's incoming request list (other user sent request)
    // 4) The current user's outgoing request list (current user sent request)
    // As a result, this will match the two users.
    // What should we do when users match?
    // First, create array for matched users in database
    // This will share location between the user and the people in their matched list
    // How will user's receive the location?
    // A cloud call will send back the location of the other user as long as they're matched
    // If they are no longer matched, then the cloud function will fail beacause it can't find
    // the given user UID in the matched list

    // Display finish button if the other person exists in my incoming and outgoing list

//    List<dynamic> loggedInUserIncomingSelfieReferences =
//        currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests];
//    List<dynamic> loggedInUserOutgoingSelfieReferences =
//        currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests];

    // Check if other use sent a selfie request
//    loggedInUserIncomingSelfieReferences.forEach((reference) {
//      if (reference == otherUserDocumentSnapshot.reference) {
//        isOtherUserInCurrentUserIncomingSelfieRequestList = true;
//        print("Other user sent a selfie request to current user");
//      }
//    });

    // Check if loggedInuser sent a selfie request to other user
//    loggedInUserOutgoingSelfieReferences.forEach((reference) {
//      print('${reference.toString()} ...');
//      if (reference == otherUserDocumentSnapshot.reference) {
//        isOtherUserInCurrentUserOutgoingSelfieRequestList = true;
//        print("Other user recieved a selfie request from current user");
//      }
//    });

    // Two conditions for accept selfie button to appear on the current user
    // 1) If the current user recieved a selfie request from other user other
    // 2) If the other user sent a selfie request to current user
    // Logic should not be done on client side because the client should not have access to the other users incoming and outgoing
    // Logic should be done on a cloud function...
    // Cloud function will take two paramters, logged in user (which is in by default) and otheruser snapshot to obtain documentID

    return HeroProfileDetails(
      onSelfieRequestTap: () {
        _onSelfieRequestTap(otherUserDocumentSnapshot);
      },
      onSelfieAcceptTap: () {
        _onSelfieAcceptTap(otherUserDocumentSnapshot);
      },
      onSelfieFinishTap: () {
        // loggedInUser will remove otherUser from incomginSelfieRequestList and outgoingSelfieRequestList
        DocumentReference currentLoggedInUserRef = currentLoggedInUser.getHashMap[FirestoreManager.keyDocumentReference];
        List<DocumentReference> currentLoggedInUserIncomingRequests = List<DocumentReference>();
        List<DocumentReference> currentLoggedInUserOutgoingRequests = List<DocumentReference>();

        for (dynamic ref in currentLoggedInUser.getHashMap[FirestoreManager.keyIncomingSelfieRequests])
          currentLoggedInUserIncomingRequests.add(ref);

        for (dynamic ref in currentLoggedInUser.getHashMap[FirestoreManager.keyOutgoingSelfieRequests])
          currentLoggedInUserOutgoingRequests.add(ref);

        print("Removing from current user...");
        currentLoggedInUserIncomingRequests.removeWhere((doc) => doc == otherUserDocumentSnapshot.reference);
        currentLoggedInUserOutgoingRequests.removeWhere((doc) => doc == otherUserDocumentSnapshot.reference);

        currentLoggedInUserRef.updateData(
          {
            FirestoreManager.keyIncomingSelfieRequests: currentLoggedInUserIncomingRequests,
            FirestoreManager.keyOutgoingSelfieRequests: currentLoggedInUserOutgoingRequests,
          },
        );
      },
      displayAcceptButton: displayAcceptButton,
      displayRequestButton: displayRequestButton,
      displayFinishButton: displayFinishButton,
      isLoggedInUser: isLookingAtOwnProfile,
      userCircleImage: otherUserDocumentSnapshot[FirestoreManager.keyPhotos][0],
      rarityBorder: otherUserDocumentSnapshot[FirestoreManager.keyRarityBorder],
      displayName: otherUserDocumentSnapshot[FirestoreManager.keyDisplayName],
      friendliness: otherUserDocumentSnapshot[FirestoreManager.keyFriendliness],
      fame: otherUserDocumentSnapshot[FirestoreManager.keyFame],
    );
  }

  // Wrap in scaffold since it's a new page
  static wrapInScaffold(List<Widget> heros, BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: HeroProfilePage(
          pages: heros,
        ),
      ),
    );
  }

  // Construct HeroProfile widget from the information on the clicked avatar
  static pushProfileIntoView(
      String dotHeroName, String imageHeroName, DocumentReference otherUserDataReference, BuildContext context) async {
    // Get latest snapshot of the user from the database
    print("getting latest database information?");

    // Get other user data for profile display
    DocumentSnapshot otherUserDataSnapshot = await otherUserDataReference.get().catchError((error) {
      //TODO need to tell user it failed with a widget...
      print("pushProfileIntoView failed to get otherUserDataSnapshot from otherUserDataReference");
      print("The error is: $error");
      return Future.error("pushProfileIntoView failed to get otherUserDataSnapshot from otherUserDataReference");
    });

    FirestoreReadcheck.heroCreatorReads++;
    FirestoreReadcheck.printHeroCreatorReads();

    LoggedInUser currentLoggedInUser = Provider.of<LoggedInUser>(context);

    HeroProfileStart heroProfileStart =
        HeroCreator.createHeroProfileStart(dotHeroName, imageHeroName, otherUserDataSnapshot, currentLoggedInUser);

    HeroProfileDetails heroProfileDetails =
        HeroCreator.createHeroProfileDetails(otherUserDataSnapshot, context, currentLoggedInUser);
    Widget clickedProfile = HeroCreator.wrapInScaffold([heroProfileStart, heroProfileDetails], context);

    // Push that profile into view
    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
  }

  // Construct HeroProfile widget from the information on the clicked avatar
//  static pushProfileIntoView2(HeroProfileStart start, HeroProfileDetails details, BuildContext context) {
//    Widget clickedProfile = HeroCreator.wrapInScaffold([start, details], context);
//
//    // Push that profile into view
//    Navigator.push(context, MaterialPageRoute(builder: (context) => clickedProfile));
//  }

  // TODO remove loggedInUser in here since the cloud functions will handle writing
  static void _onSelfieRequestTap(DocumentSnapshot otherUserData) async {
    // TODO restrict people within distance, if they are out of distance, record malicious attempt
    final response = await Meetup.sendSelfieRequestTo(otherUserData);
    print(response.data);
    // returning objects from the cloudfirestore wold be data['bob'] if the object contains it
//    print("DONE CALLING");
//    DocumentReference loggedInUserRef = loggedInUser.getHashMap[FirestoreManager.keyDocumentReference];
//    DocumentReference otherUserRef;
//    await _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(loggedInUserRef, otherUserRef, otherUserData);
  }

  // TODO remove loggedInUser in here since the cloud functions will handle writing
  static void _onSelfieAcceptTap(DocumentSnapshot otherUserData) async {
    final response = await Meetup.sendSelfieRequestTo(otherUserData);
    print(response.data);
    final response2 = await Meetup.acceptSelfieFrom(otherUserData);
    print("RESPONSE OF BIG BIG THING <<<<<<<<<<<<<<<<<<<<<<<<<<<<,,");
    print(response2.data);

//    DocumentReference loggedInUserRef = loggedInUser.getHashMap[FirestoreManager.keyDocumentReference];
//    DocumentReference otherUserRef;
//    await _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(loggedInUserRef, otherUserRef, otherUserData);
  }

  static void _onSelfieFinishTap(DocumentSnapshot otherUserData) async {}

//  static _putLoggedInUserIntoOtherUserIncomingSelfieRequestList(
//      DocumentReference loggedInUserRef, DocumentReference otherUserRef, DocumentSnapshot otherUserData) async {
//    await Firestore.instance
//        .collection("users")
//        .where(FirestoreManager.keyDisplayName, isEqualTo: otherUserData[FirestoreManager.keyDisplayName])
//        .limit(1)
//        .getDocuments()
//        .then((snapshot) {
//      otherUserRef = snapshot.documents[0].reference;
//      FirestoreReadcheck.heroCreatorReads++;
//      FirestoreReadcheck.heroCreatorWrites++;
//      FirestoreReadcheck.printHeroCreatorReads();
//      FirestoreReadcheck.printHeroCreatorWrites();
//      otherUserRef.updateData({
//        FirestoreManager.keyIncomingSelfieRequests: FieldValue.arrayUnion([loggedInUserRef]),
//      });
//    });

//    await loggedInUserRef.updateData({
//      FirestoreManager.keyOutgoingSelfieRequests: FieldValue.arrayUnion([otherUserRef]),
//    });
//  }

  static _checkSame(LoggedInUser loggedInUser, DocumentSnapshot otherUser) {
    String otherUserName = otherUser[FirestoreManager.keyDisplayName];
    String currentLoggedInUserName = loggedInUser.getHashMap[FirestoreManager.keyDisplayName];
    return otherUserName == currentLoggedInUserName;
  }
}
