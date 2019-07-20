import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/constants/questions.dart';
import 'package:cosplay_app/animations/AnimateOut.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/classes/QuestionController.dart';
import 'package:simple_animations/simple_animations.dart';
import 'dart:collection';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  var userData = HashMap();
  QuestionController questionController = QuestionController();
  int _currentYearPicker = 1;
  int _currentMonthPicker = 1;
  List<List<TextSpan>> questions = new List<List<TextSpan>>();
  AnimationController animationController;
  Animation animationOpacity;
  Animation animationTransformQuestion;
  Animation animationTransformButtons;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
  Widget renderPicker(int currentValue, Function setCurrentValue) {
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

  Widget renderYearText() {
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

  Widget renderMonthText() {
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

  Widget renderQuestion(List<TextSpan> question, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimateOut(
          start: 0.0,
          controller: animationController,
          myChild: Padding(
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
                  children: question,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        AnimateOut(
          start: 0.3,
          controller: animationController,
          myChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundButton(icon: Icons.clear),
              SizedBox(width: kBoxGap + 40.0),
              RoundButton(
                icon: Icons.check,
                onTap: () {
                  // Confirmed
                  animationController.forward();
                  questionController.incrementQuestionIndex();
                  setState(() {}); // Causes rebuild
                  saveCurrentQuestionData();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        SizedBox(height: 20.0),
        AnimateOut(
          start: 0.5,
          controller: animationController,
          myChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  renderYearText(),
                  SizedBox(height: kBoxGap),
                  renderPicker(_currentYearPicker, (newValue) {
                    setState(() {
                      _currentYearPicker = newValue;
                    });
                  })
                ],
              ),
              SizedBox(width: kBoxGap),
              Column(
                children: <Widget>[
                  renderMonthText(),
                  SizedBox(height: kBoxGap),
                  renderPicker(_currentMonthPicker, (newValue) {
                    setState(() {
                      _currentMonthPicker = newValue;
                    });
                  }),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
//    final double width = MediaQuery.of(context).size.width;
//    animationTransformQuestion = Tween(begin: 0.0, end: width * -1).animate(
//      CurvedAnimation(
//        parent: animationController,
//        curve: Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
//      ),
//    );
//    animationTransformButtons = Tween(begin: 0.0, end: width * -1).animate(
//      CurvedAnimation(
//        parent: animationController,
//        curve: Interval(0.2, 1.0, curve: Curves.easeInOutCubic),
//      ),
//    );
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
          child: Stack(
            children: <Widget>[
              renderQuestion(q1(context), context),
              //renderQuestion(q2(context)),
            ],
          ),
        ),
      ),
    );
  }
}
