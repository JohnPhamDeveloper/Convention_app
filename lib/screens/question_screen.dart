import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.2, 0.4, 0.9],
          colors: [
            Colors.cyan[500],
            Colors.cyan[400],
            Colors.cyan[300],
            Colors.cyan[200],
          ],
        ),
      ),
    );
  }
}
