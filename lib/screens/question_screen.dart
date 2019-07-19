import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/constants/questions.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/classes/QuestionController.dart';
import 'dart:collection';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var userData = HashMap();
  QuestionController questionController = QuestionController();
  int _currentYearPicker = 1;
  int _currentMonthPicker = 1;
  List<List<TextSpan>> questions = new List<List<TextSpan>>();

  @override
  void initState() {
    super.initState();
  }

  void initQuestions(context) {
    // We need to clear the questions every build for context (should change this?)
    questionController.clearQuestions();

    // Questions are from questions.dart
    questionController.addQuestion(q1(context));
    questionController.addQuestion(q2(context));
    questionController.addQuestion(q3(context));
    questionController.addQuestion(q4(context));
  }

  void saveCurrentQuestionData() {
    switch (questionController.getCurrentQuestionIndex()) {
      case 1:
        userData['isCosplayer'] = true;
        print(userData);
        break;
      case 2:
        userData['isPhotographer'] = true;
        print(userData);
        break;
      case 3:
        userData['yearsCosplayed'] = _currentYearPicker;
        userData['monthsCosplayed'] = _currentMonthPicker;
        print(userData);
        break;
      case 4:
        userData['yearsPhotographer'] = _currentYearPicker;
        userData['monthsPhotographer'] = _currentMonthPicker;
        print(userData);
        break;
    }
  }

  // Displays year picker and a function that will set the state with the picker value
  Widget showPicker(int currentValue, Function setCurrentValue) {
    if (questionController.getCurrentQuestionIndex() == 2 ||
        questionController.getCurrentQuestionIndex() == 3) {
      return NumberPicker.integer(
        listViewWidth: 150.0,
        itemExtent: 60.0,
        initialValue: currentValue,
        minValue: 0,
        maxValue: 100,
        onChanged: (newValue) => setCurrentValue(newValue),
      );
    } else {
      return Container(); // Return a container since number picker shouldnt be displayed
    }
  }

  Widget showYearText() {
    if (questionController.getCurrentQuestionIndex() == 2 ||
        questionController.getCurrentQuestionIndex() == 3) {
      return Text(
        "Select year(s)",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  Widget showMonthText() {
    if (questionController.getCurrentQuestionIndex() == 2 ||
        questionController.getCurrentQuestionIndex() == 3) {
      return Text(
        "Select month(s)",
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
                        fontSize: 30.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      children: questionController.getQuestion(),
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
                      // Confirmed
                      questionController.incrementQuestionIndex();
                      setState(() {}); // Causes rebuild
                      saveCurrentQuestionData();
                    },
                  ),
                ],
              ),
              SizedBox(height: kBoxGap + 50.0),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      showYearText(),
                      SizedBox(height: kBoxGap),
                      showPicker(_currentYearPicker, (newValue) {
                        setState(() {
                          _currentYearPicker = newValue;
                        });
                      })
                    ],
                  ),
                  SizedBox(width: kBoxGap),
                  Column(
                    children: <Widget>[
                      showMonthText(),
                      SizedBox(height: kBoxGap),
                      showPicker(_currentMonthPicker, (newValue) {
                        setState(() {
                          _currentMonthPicker = newValue;
                        });
                      }),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
