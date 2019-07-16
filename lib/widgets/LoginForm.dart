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

  IconFormField({@required this.hintText, @required this.invalidText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hintText, labelText: hintText),
      validator: (value) {
        if (value.isEmpty) {
          return invalidText;
        }
        return null; // No errors
      },
    );
  }
}
