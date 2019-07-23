import 'package:cosplay_app/classes/QuestionBank.dart';
import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/question/Question.dart';
import 'dart:collection';

class Questions extends StatefulWidget {
  final QuestionBank questionBank;

  Questions({@required this.questionBank});

  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> with TickerProviderStateMixin {
  var userData = HashMap();
  List<AnimationController> animationControllerList =
      List<AnimationController>();
  List<Picker> pickers = new List<Picker>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questionBank.getQuestionsLength(); i++) {
      AnimationController controller =
          AnimationController(duration: Duration(seconds: 1), vsync: this);
      animationControllerList.add(controller);
      Picker picker = Picker(year: 1, month: 1);
      pickers.add(picker);
    }
  }

  @override
  void dispose() {
    for (AnimationController animationController in animationControllerList) {
      animationController.dispose();
    }
    super.dispose();
  }

  List<Widget> renderQuestions(BuildContext context) {
    List<Widget> questionPages = List<Widget>();

    bool doesCurrentQuestionNeedNumberPicker(index) {
      if (index == 2 || index == 3) return true;
      return false;
    }

    // Add all question widgets to list
    for (int i = 0; i < widget.questionBank.getQuestionsLength(); i++) {
      questionPages.add(Question(
        animationController: animationControllerList[i],
        questionText: widget.questionBank.getQuestion(i),
        onCheckTap: () {
          handleOnCheckClick(i);
        },
        showPicker: doesCurrentQuestionNeedNumberPicker(i),
        onYearChange: (value) {
          setState(() {
            pickers[i].year = value;
          });
        },
        onMonthChange: (value) {
          setState(() {
            pickers[i].month = value;
          });
        },
      ));

      // Animate first question in
      animationControllerList[0].forward();
    }

    // Will be put on a stack so reverse to get correct question order
    questionPages.reversed;

    return questionPages;
  }

  void handleOnCheckClick(int index) {
    saveCurrentQuestionData(index);
    int nextQuestionIndex = index + 1;

    // Only animate next question in if there is a next question
    if (nextQuestionIndex <= widget.questionBank.getQuestionsLength() - 1) {
      widget.questionBank.incrementQuestionIndex();
      animationControllerList[nextQuestionIndex].forward();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: renderQuestions(context),
    );
  }
}

class Picker {
  int year = 1;
  int month = 1;

  Picker({this.year, this.month});
}

//class QuestionManager {
//  QuestionBank _questionBank;
//  List<AnimationController> _animationControllerList;
//  List<Picker> pickers;
//
//  QuestionManager(this._questionBank) {
//    _animationControllerList = List<AnimationController>();
//
//    for (int i = 0; i <= _questionBank.getQuestionsLength() - 1; i++) {
////      AnimationController controller =
////      AnimationController(duration: Duration(seconds: 1), vsync: this);
////      animationControllerList.add(controller);
////      Picker picker = Picker(year: 1, month: 1);
////      pickers.add(picker);
//    }
//  }
//}
//
//class Picker {
//  int year = 1;
//  int month = 1;
//
//  Picker({this.year, this.month});
//}
