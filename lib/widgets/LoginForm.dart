import 'package:flutter/material.dart';
import 'HyperButton.dart';
import 'IconFormField.dart';
import 'SuperButton.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _bRememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_printText);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _printText() {
    print('${_emailController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconFormField(
            hintText: "Email",
            invalidText: "Invalid Email",
            icon: Icons.email,
            controller: _emailController,
          ),
          IconFormField(
            hintText: "Password",
            invalidText: "Invalid Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _passwordController,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Switch(
                value: _bRememberMe,
                onChanged: (value) {
                  setState(() {
                    _bRememberMe = !_bRememberMe;
                  });
                },
              ),
              HyperButton(),
            ],
          ),
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
              }),
        ],
      ),
    );
  }
}
