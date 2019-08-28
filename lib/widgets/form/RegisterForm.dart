import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/HyperButton.dart';
import 'package:cosplay_app/widgets/form/IconFormField.dart';
import 'package:cosplay_app/widgets/form/SuperButtonForm.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:flutter/animation.dart';
import "package:cosplay_app/animations/AnimationWrapper.dart";
import "package:cosplay_app/animations/AnimationBounceIn.dart";
import 'package:cosplay_app/verification/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  final Function onSavedData;

  RegisterForm({this.onSavedData});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    Future<FirebaseUser> currentUser = _auth.currentUser();
    // User signed in already?
    if (currentUser != null) {
      print(currentUser);
    } else {
      print("Current user is null!");
    }

    animationController = AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: false,
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Email
          AnimationWrapper(
            controller: animationController,
            start: 0.0,
            child: IconFormField(
              hintText: "Phone Number",
              invalidText: "Invalid phone number",
              icon: Icons.phone,
              controller: _phoneController,
              textInputType: TextInputType.phone,
              validator: (value) {
                //return validateEmail(value);
                return validatePhone(value);
              },
            ),
          ),
          SizedBox(height: kBoxGap),
          // Password
          AnimationWrapper(
            controller: animationController,
            start: 0.1,
            child: IconFormField(
              hintText: "Password",
              invalidText: "Invalid Password",
              icon: Icons.lock,
              obscureText: true,
              controller: _passwordController,
              textInputType: TextInputType.text,
              validator: (value) {
                return validatePassword(value);
              },
            ),
          ),
          SizedBox(height: kBoxGap),
          SizedBox(height: kBoxGap),
          // Login Button
          AnimationBounceIn(
            durationMilliseconds: 0,
            durationSeconds: 3,
            delayMilliseconds: 500,
            child: SuperButtonForm(
              text: "REGISTER",
              color: Theme.of(context).primaryColor,
              validated: () {
                return _formKey.currentState.validate(); // All form fields are valid?
              },
              onPress: () async {
                FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: _phoneController.text,
                    timeout: const Duration(seconds: 5),
                    verificationCompleted: (user) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Verified!'),
                        ),
                      );
                    },
                    verificationFailed: (authException) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to register, please try again! ' + authException.message),
                        ),
                      );
                    },
                    codeSent: (String verificationId, [int token]) {
                      print('Code sent to ${_phoneController.text}');
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      print('Code timed out');
                    });

                // Debug
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Processing Data for ${_phoneController.text} of ${_passwordController.text}'),
                  ),
                );

                // Dismiss keyboard
                FocusScope.of(context).requestFocus(new FocusNode());

                // Artificial wait time
                await Future.delayed(Duration(seconds: 2), () {});

                // Registers into database and puts default values for user profile
                await FirestoreManager.createUserInDatabase(
                  fame: 999,
                  friendliness: 666,
                  dateRegistered: Timestamp.now(),
                  displayName: "Registered",
                  photoUrls: ['https://c.pxhere.com/photos/fc/88/boy_portrait_people_man_anime_face_35mm_comic-185839.jpg!d'],
                  cosplayName: "Reg Man",
                  seriesName: 'Pepsi',
                  isCosplayer: true,
                  isPhotographer: false,
                  isCongoer: false,
                  rarityBorder: 0,
                  //                 cosplayerCost: "\$52.00/hr",
                  photographerCost: "\$42.00/hr",
//                  photographyMonthsExperience: 2,
//                  photographyYearsExperience: 5,
//                  cosplayMonthsExperience: 0,
//                  cosplayYearsExperience: 0,
                ).then((user) {
                  print('success');
                }).catchError((error) {
                  print('Failed to register, please try again!' + error);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to register, please try again!'),
                    ),
                  );
                });

                // Then push to question screens which can be optionally skipped

                // Go to login screen
                // Navigator.pushNamed(context, '/');
              },
            ),
          ),
          SizedBox(height: kBoxGap),
          // Signup Button
          AnimationWrapper(
            controller: animationController,
            start: 0.5,
            direction: AnimationDirection.BOTTOM,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already registered? ", style: kTextStyleNotImportant()),
                HyperButton(
                  text: "Sign In",
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
