import 'package:flutter/material.dart';
import 'HyperButton.dart';
import 'IconFormField.dart';
import 'SuperButtonForm.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:flutter/animation.dart';
import "package:cosplay_app/animations/AnimationWrapper.dart";
import "package:cosplay_app/animations/AnimationBounceIn.dart";
import 'package:cosplay_app/verification/verification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForm extends StatefulWidget {
  final Function onLoginPress;

  LoginForm({this.onLoginPress});
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _bRememberMe = true;
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
          // Remember me and forgot password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AnimationWrapper(
                controller: animationController,
                start: 0.3,
                child: Row(
                  children: <Widget>[
                    Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: _bRememberMe,
                      onChanged: (value) {
                        setState(() {
                          _bRememberMe = !_bRememberMe;
                        });
                      },
                    ),
                    Text("Remember Me", style: kTextStyleNotImportant()),
                  ],
                ),
              ),
              AnimationWrapper(
                controller: animationController,
                start: 0.3,
                direction: AnimationDirection.RIGHT,
                child: HyperButton(text: "Forgot Password?"),
              ),
            ],
          ),
          SizedBox(height: kBoxGap),
          // Login Button
          AnimationBounceIn(
            durationMilliseconds: 0,
            durationSeconds: 3,
            delayMilliseconds: 500,
            child: SuperButtonForm(
              text: "LOG IN",
              color: Theme.of(context).primaryColor,
              validated: () {
                return _formKey.currentState
                    .validate(); // All form fields are valid?
              },
              onPress: () async {
                widget.onLoginPress();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Processing Data for ${_emailController.text} of ${_passwordController.text}'),
                  ),
                );

                // Dismiss keyboard
                FocusScope.of(context).requestFocus(new FocusNode());

                await Future.delayed(Duration(seconds: 2), () {});
                Navigator.pushNamed(context, '/question');
              },
            ),
          ),
          SizedBox(height: kBoxGap + 20.0),
          // Signup Button
          AnimationWrapper(
            controller: animationController,
            start: 0.5,
            direction: AnimationDirection.BOTTOM,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("New user? ", style: kTextStyleNotImportant()),
                HyperButton(text: "Sign Up"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
