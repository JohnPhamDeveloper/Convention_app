import 'package:flutter/material.dart';
import 'package:cosplay_app/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(child: QuestionDisplay()),
              ),
              SizedBox(height: kBoxGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[RoundButton(icon: Icons.check)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionDisplay extends StatelessWidget {
  // Store how many cosplayers and photographers went on site

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(text: 'Are you a '),
          TextSpan(
            text: 'Cosplayer ',
            style: kTextStyleImportant(context),
          ),
          TextSpan(text: 'or '),
          TextSpan(
            text: 'Photographer',
            style: kTextStyleImportant(context),
          ),
          TextSpan(text: '?')
        ],
      ),
    );
  }
}
