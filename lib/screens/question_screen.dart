import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';
import 'package:cosplay_app/constants/questions.dart';
import 'package:cosplay_app/animations/AnimationWrapper.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/classes/QuestionController.dart';
import 'dart:collection';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  var userData = HashMap();
  QuestionController questionController = QuestionController();
  int _currentYearPicker = 1;
  int _currentMonthPicker = 1;
  List<List<TextSpan>> questions = List<List<TextSpan>>();
  AnimationController animationController;
  List<AnimationController> animationControllerList =
      List<AnimationController>();
  List<AnimationDirection> animationDirectionList = List<AnimationDirection>();
  List<bool> animationIsOutList = List<bool>();
  List<bool> showPicker = List<bool>();

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
    animationController.dispose();
    for (AnimationController animationController in animationControllerList) {
      animationController.dispose();
    }
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
  Widget renderPicker(int index, int currentValue, Function setCurrentValue) {
    if (index == 2 || index == 3) {
      return NumberPicker.integer(
        listViewWidth: 150.0,
        itemExtent: 60.0,
        initialValue: currentValue,
        minValue: 0,
        maxValue: 100,
        onChanged: (newValue) => setCurrentValue(newValue),
      );
    } else {
      return Container(); // Return a container since number picker shouldn't be displayed
    }
  }

  Widget renderYearText(index) {
    if (index == 2 || index == 3) {
      return Text(
        "Select year(s)",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  Widget renderMonthText(index) {
    if (index == 2 || index == 3) {
      return Text(
        "Select month(s)",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  Widget createQuestionWidget(int index,
      {AnimationDirection animationDirection: AnimationDirection.RIGHT,
      bool isOut: false}) {
    animationDirectionList.add(animationDirection);
    animationIsOutList.add(isOut);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimationWrapper(
          start: 0.0,
          controller: animationControllerList[index],
          direction: animationDirectionList[index],
          isOut: animationIsOutList[index],
          child: Padding(
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
                  children: questionController.getQuestion(index),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        AnimationWrapper(
          start: 0.3,
          controller: animationControllerList[index],
          direction: animationDirectionList[index],
          isOut: animationIsOutList[index],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundButton(icon: Icons.clear),
              SizedBox(width: kBoxGap + 40.0),
              RoundButton(
                icon: Icons.check,
                onTap: () {
                  // The next question should animate in
                  setState(() {
                    animationIsOutList[index] = true; // Animate out
                    animationDirectionList[index] =
                        AnimationDirection.LEFT; // Animate out to left
                  });
                  animationControllerList[index].reset();
                  animationControllerList[index]
                      .forward(); // Animate with new properties
                  animationControllerList[index + 1].reset();
                  animationControllerList[index + 1].forward();
                  questionController.incrementQuestionIndex();
                  saveCurrentQuestionData();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        SizedBox(height: 20.0),
        AnimationWrapper(
          start: 0.5,
          controller: animationControllerList[index],
          direction: animationDirectionList[index],
          isOut: animationIsOutList[index],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  renderYearText(index),
                  SizedBox(height: kBoxGap),
                  renderPicker(index, _currentYearPicker, (newValue) {
                    setState(() {
                      _currentYearPicker = newValue;
                    });
                  })
                ],
              ),
              SizedBox(width: kBoxGap),
              Column(
                children: <Widget>[
                  renderMonthText(index),
                  SizedBox(height: kBoxGap),
                  renderPicker(index, _currentMonthPicker, (newValue) {
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

  List<Widget> renderQuestions(BuildContext context) {
    List<Widget> questionPages = List<Widget>();
    double width = MediaQuery.of(context).size.width;

    // First question won't need the animation in wrapped
    questionPages.add(
        createQuestionWidget(0, animationDirection: AnimationDirection.RIGHT));
    animationControllerList[0].forward();

    // Wrap all questions after that with animationIn and animationOut
    for (int i = 1; i < questionController.getQuestionsLength(); i++) {
      // Create button off screen to the right
      questionPages.add(createQuestionWidget(i));
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
