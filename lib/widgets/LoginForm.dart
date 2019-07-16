import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
          RaisedButton(
            child: Text("Login"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Processing Data for ${_emailController.text} of ${_passwordController.text}'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class IconFormField extends StatefulWidget {
  IconFormField({
    Key key,
    @required this.hintText,
    @required this.invalidText,
    this.icon,
    this.obscureText = false,
    this.controller,
  }) : super(key: key);

  final hintText;
  final invalidText;
  final icon;
  final obscureText;
  final controller;

  @override
  _IconFormFieldState createState() => _IconFormFieldState();
}

class _IconFormFieldState extends State<IconFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.hintText,
        prefixIcon: Icon(widget.icon),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return widget.invalidText;
        }
        return null; // No errors
      },
    );
  }
}
