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

class RegisterForm extends StatefulWidget {
  final Function onRegisterPress;

  RegisterForm({this.onRegisterPress});
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
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

    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    _emailController.dispose();
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
              hintText: "Email",
              invalidText: "Invalid Email",
              icon: Icons.email,
              controller: _emailController,
              textInputType: TextInputType.emailAddress,
              validator: (value) {
                return validateEmail(value);
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
                return _formKey.currentState
                    .validate(); // All form fields are valid?
              },
              onPress: () async {
                widget.onRegisterPress();

                // Register user
                try {
                  FirebaseUser user =
                      await _auth.createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                  print(
                      "-------------------user successfully registered------------------------------------");
                } catch (e) {
                  print(
                      "----------------RegisterForm: $e----------------------");
                  print(e.code);
                }

                // Debug
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Processing Data for ${_emailController.text} of ${_passwordController.text}'),
                  ),
                );

                // Dismiss keyboard
                FocusScope.of(context).requestFocus(new FocusNode());

                // Artificial wait time
                await Future.delayed(Duration(seconds: 2), () {});

                // Go to login screen
                Navigator.pushNamed(context, '/');
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
