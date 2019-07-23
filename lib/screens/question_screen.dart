import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/questions.dart';
import 'package:cosplay_app/classes/Questions.dart';
import 'package:cosplay_app/classes/QuestionBank.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  QuestionBank questionBank = QuestionBank();

  void initQuestions(context) {
    // We need to clear the questions every build for context (should change this?)
    questionBank.clearQuestions();

    // Questions are from questions.dart
    questionBank.addQuestion(q1(context));
    questionBank.addQuestion(q2(context));
    questionBank.addQuestion(q3(context));
    questionBank.addQuestion(q4(context));
  }

  @override
  Widget build(BuildContext context) {
    //  Create questions; need context for theme
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
          child: Questions(questionBank: questionBank),
        ),
      ),
    );
  }
}

class Picker {
  int year = 1;
  int month = 1;

  Picker({this.year, this.month});
}
