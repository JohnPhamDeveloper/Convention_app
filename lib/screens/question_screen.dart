import 'package:flutter/material.dart';
import 'package:cosplay_app/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/questions.dart';
import 'package:numberpicker/numberpicker.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  int _currentYearPicker = 1;
  int _currentMonthPicker = 0;
  bool _showNumberPicker = true;
  bool _showYearText = true;
  List<List<TextSpan>> questions = new List<List<TextSpan>>();

  @override
  void initState() {
    super.initState();
  }

  void initQuestions(context) {
    questions.clear();

    // Questions are from questions.dart
    questions.add(q1(context));
    questions.add(q2(context));
    questions.add(q3(context));
  }

  List<TextSpan> getQuestion(int index) {
    if (questions.isEmpty || index >= questions.length) {
      return questions[questions.length - 1];
    } else {
      return questions[index];
    }
  }

  void incrementQuestionIndex() {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
      }
    });
  }

  // Show number picker widget only on questions that need it
  Widget showNumberPicker() {
    if (_currentQuestionIndex == 2) {
      return NumberPicker.integer(
        listViewWidth: 50.0,
        itemExtent: 40.0,
        initialValue: _currentYearPicker,
        minValue: 0,
        maxValue: 100,
        onChanged: (newValue) =>
            setState(() => {_currentYearPicker = newValue}),
      );
    } else {
      return Container(); // Return a container since number picker shouldnt be displayed
    }
  }

  Widget showYearText() {
    if (_currentQuestionIndex == 2) {
      return Text(
        "Select year(s)",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    initQuestions(context);
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
                padding: const EdgeInsets.only(left: 22.0, right: 22.0),
                child: Container(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      children: getQuestion(_currentQuestionIndex),
                    ),
                  ),
                ),
              ),
              SizedBox(height: kBoxGap + 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RoundButton(icon: Icons.clear),
                  SizedBox(width: kBoxGap + 20.0),
                  RoundButton(
                    icon: Icons.check,
                    onTap: () {
                      incrementQuestionIndex();
                    },
                  ),
                ],
              ),
              SizedBox(height: kBoxGap + 50.0),
              Column(
                children: <Widget>[
                  showYearText(),
                  SizedBox(height: 20.0),
                  showNumberPicker(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
