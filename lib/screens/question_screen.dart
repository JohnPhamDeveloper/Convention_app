import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/constants/questions.dart';
import 'package:cosplay_app/animations/AnimationWrapper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/classes/QuestionBank.dart';
import 'dart:collection';
import 'package:cosplay_app/Question.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  var userData = HashMap();
  QuestionBank questionBank = QuestionBank();
  List<List<TextSpan>> questions = List<List<TextSpan>>();
  List<AnimationController> animationControllerList =
      List<AnimationController>();
  List<Picker> pickers = new List<Picker>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 5; i++) {
      AnimationController controller =
          AnimationController(duration: Duration(seconds: 1), vsync: this);
      animationControllerList.add(controller);
    }
  }

  @override
  void dispose() {
    for (AnimationController animationController in animationControllerList) {
      animationController.dispose();
    }
    super.dispose();
  }

  void initQuestions(context) {
    // We need to clear the questions every build for context (should change this?)
    questionBank.clearQuestions();

    // Questions are from questions.dart
    questionBank.addQuestion(q1(context));
    questionBank.addQuestion(q2(context));
    questionBank.addQuestion(q3(context));
    questionBank.addQuestion(q4(context));
  }

  // Save data depending on which question the user is at
  void saveCurrentQuestionData(int index) {
    switch (index) {
      case 0:
        userData['isCosplayer'] = true;
        print(userData);
        break;
      case 1:
        userData['isPhotographer'] = true;
        print(userData);
        break;
      case 2:
        userData['yearsCosplayed'] = pickers[index].year;
        userData['monthsCosplayed'] = pickers[index].month;
        print(userData);
        break;
      case 3:
        userData['yearsPhotographer'] = pickers[index].year;
        userData['monthsPhotographer'] = pickers[index].month;
        print(userData);
        break;
    }
  }

  void handleOnCheckClick(int index) {
    int nextQuestionIndex = index + 1;
    saveCurrentQuestionData(index);
    questionBank.incrementQuestionIndex();

    // Only animate next question in if there is a next question
    if (nextQuestionIndex < questionBank.getQuestionsLength() - 1) {
      animationControllerList[nextQuestionIndex].forward();
    }
  }

  List<Widget> renderQuestions(BuildContext context) {
    List<Widget> questionPages = List<Widget>();

    bool doesCurrentQuestionNeedNumberPicker(index) {
      if (index == 2 || index == 3) return true;
      return false;
    }

    // Wrap all questions after that with animationIn and animationOut
    for (int i = 0; i < questionBank.getQuestionsLength(); i++) {
      // Create question off screen to the right
      questionPages.add(Question(
        animationController: animationControllerList[i],
        questionText: questionBank.getQuestion(i),
        onCheckTap: (value) {},
        showPicker: doesCurrentQuestionNeedNumberPicker(i),
        onYearChange: (value) {},
        onMonthChange: (value) {},
      ));

      // Animate first question in
      animationControllerList[0].forward();
    }

    // Will be put on a stack so reverse to get correct question order
    questionPages.reversed;

    return questionPages;
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
          child: Stack(
            children: renderQuestions(context),
          ),
        ),
      ),
    );
  }
}

class Picker {
  int year;
  int month;
}
