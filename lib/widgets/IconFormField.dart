import 'package:flutter/material.dart';

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
