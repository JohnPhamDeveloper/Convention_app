import 'package:flutter/material.dart';

class IconFormField extends StatefulWidget {
  IconFormField({
    Key key,
    @required this.hintText,
    @required this.invalidText,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.textInputType,
    this.validator,
  }) : super(key: key);

  final String hintText;
  final String invalidText;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function validator;

  @override
  _IconFormFieldState createState() => _IconFormFieldState();
}

class _IconFormFieldState extends State<IconFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      obscureText: widget.obscureText,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.hintText,
        prefixIcon: Icon(widget.icon),
      ),
      validator: (value) {
        return widget.validator(value);
      },
    );
  }
}
