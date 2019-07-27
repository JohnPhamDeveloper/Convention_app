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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cosplay_app/widgets/LoadingIndicator.dart';

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
  bool _isLoading = false;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    // Should be await
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

  void _setIsLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
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
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          child: Form(
            autovalidate: false,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      child:
                          HyperButton(text: "Forgot Password?", onTap: () {}),
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

                      // print(_isLoading);
                      _setIsLoading(true);

                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Attempting signin for ${_emailController.text}'),
                        ),
                      );

                      // Dismiss keyboard
                      FocusScope.of(context).requestFocus(new FocusNode());

                      // Debug wait
                      await Future.delayed(Duration(seconds: 2), () {});

                      try {
                        FirebaseUser user =
                            await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        print("Sign in successful!");
                        _setIsLoading(false);
                        Navigator.pushNamed(context, '/question');
                      } catch (e) {
                        _setIsLoading(false);
                        print(e);
                      }
                    },
                  ),
                ),
                SizedBox(height: kBoxGap - 5),
                // Signup Button
                AnimationWrapper(
                  controller: animationController,
                  start: 0.5,
                  direction: AnimationDirection.BOTTOM,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("New user? ", style: kTextStyleNotImportant()),
                      HyperButton(
                          text: "Sign Up",
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        LoadingIndicator(),
      ],
    );
  }
}
