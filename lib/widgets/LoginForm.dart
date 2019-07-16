import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          IconFormField(
              hintText: "Email",
              invalidText: "Invalid Email",
              icon: Icons.email),
          IconFormField(
            hintText: "Password",
            invalidText: "Invalid Password",
            icon: Icons.lock,
            obscureText: true,
          ),
          RaisedButton(
            child: Text("Login"),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
          ),
        ],
      ),
    );
  }
}

class IconFormField extends StatelessWidget {
  final hintText;
  final invalidText;
  final icon;
  final obscureText;

  IconFormField(
      {@required this.hintText,
      @required this.invalidText,
      this.icon,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: hintText,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return invalidText;
        }
        return null; // No errors
      },
    );
  }
}
