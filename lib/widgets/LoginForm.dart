import 'package:flutter/material.dart';
import 'HyperButton.dart';
import 'IconFormField.dart';
import 'SuperButton.dart';
import 'package:cosplay_app/constants.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _bRememberMe = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
          IconFormField(
            hintText: "Email",
            invalidText: "Invalid Email",
            icon: Icons.email,
            controller: _emailController,
            textInputType: TextInputType.emailAddress,
            validator: (value) {
              return validateEmail(value);
            },
          ),
          SizedBox(height: kBoxGap),
          IconFormField(
            hintText: "Password",
            invalidText: "Invalid Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _passwordController,
            textInputType: TextInputType.text,
            validator: (value) {
              validatePassword(value);
            },
          ),
          SizedBox(height: kBoxGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Switch(
                    value: _bRememberMe,
                    onChanged: (value) {
                      setState(() {
                        _bRememberMe = !_bRememberMe;
                      });
                    },
                  ),
                  Text("Remember Me"),
                ],
              ),
              HyperButton(text: "Forgot Password?"),
            ],
          ),
          SizedBox(height: kBoxGap),
          SuperButton(
            text: "LOG IN",
            validated: () {
              return _formKey.currentState.validate();
            },
            onPress: () {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Processing Data for ${_emailController.text} of ${_passwordController.text}'),
                ),
              );
              Navigator.pushNamed(context, '/question');
            },
          ),
          SizedBox(height: kBoxGap + 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("New user? "),
              HyperButton(text: "Sign Up"),
            ],
          ),
        ],
      ),
    );
  }
}

String validatePassword(String value) {
  if (value.isEmpty) {
    return "Please enter your password";
  } else if (value.length < 6) {
    return "Password must be greater than 5 characters";
  } else {
    return null;
  }
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return 'Enter a valid email';
  else
    return null;
}
