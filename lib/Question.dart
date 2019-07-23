import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cosplay_app/animations/AnimationWrapper.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class Question extends StatefulWidget {
  final AnimationController animationController;
  final AnimationDirection animationDirection;
  final bool animationIsOut;
  final bool showPicker;
  final int currentYearPicker;
  final int currentMonthPicker;
  final List<TextSpan> questionText;
  final Function onCheckTap;
  final Function onYearChange;
  final Function onMonthChange;

  Question(
      {@required this.animationController,
      @required this.questionText,
      @required this.onCheckTap,
      @required this.onYearChange,
      @required this.onMonthChange,
      this.animationDirection = AnimationDirection.RIGHT,
      this.animationIsOut = false,
      this.showPicker = false,
      this.currentMonthPicker = 1,
      this.currentYearPicker = 1});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  AnimationDirection animationDirection;
  int currentYearPicker;
  int currentMonthPicker;
  bool animationIsOut;

  @override
  void initState() {
    super.initState();
    animationIsOut = widget.animationIsOut;
    animationDirection = widget.animationDirection;
    currentYearPicker = widget.currentYearPicker;
    currentMonthPicker = widget.currentMonthPicker;
  }

  Widget createQuestionWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AnimationWrapper(
          start: 0.0,
          controller: widget.animationController,
          direction: animationDirection,
          isOut: animationIsOut,
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
                  children: widget.questionText,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        AnimationWrapper(
          start: 0.3,
          controller: widget.animationController,
          direction: animationDirection,
          isOut: animationIsOut,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundButton(icon: Icons.clear),
              SizedBox(width: kBoxGap + 40.0),
              RoundButton(
                icon: Icons.check,
                onTap: () {
                  changeAnimation(); // Animate this question out
                  widget.onCheckTap();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: kBoxGap + 50.0),
        SizedBox(height: 20.0),
        AnimationWrapper(
          start: 0.5,
          controller: widget.animationController,
          direction: animationDirection,
          isOut: animationIsOut,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _renderPickerText("Select year(s)"),
                  SizedBox(height: kBoxGap),
                  _renderPicker(currentYearPicker, (year) {
                    setState(() {
                      currentYearPicker = year;
                    });
                  }),
                ],
              ),
              SizedBox(width: kBoxGap),
              Column(
                children: <Widget>[
                  _renderPickerText("Select month(s)"),
                  SizedBox(height: kBoxGap),
                  _renderPicker(currentMonthPicker, (month) {
                    setState(() {
                      currentMonthPicker = month;
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

  // Animation will be animating out
  void changeAnimation() {
    setState(() {
      animationDirection = AnimationDirection.LEFT;
      animationIsOut = true;
      // Since we reset the animation values, we need to restart the animation controller
      widget.animationController.reset();
      widget.animationController.forward();
    });
  }

  Widget _renderPicker(int initialValue, Function callback) {
    // Only render picker on these indexes
    if (widget.showPicker) {
      return NumberPicker.integer(
        listViewWidth: 150.0,
        itemExtent: 60.0,
        initialValue: initialValue,
        minValue: 0,
        maxValue: 100,
        onChanged: (newValue) {
          callback(newValue);
          widget.onCheckTap(newValue);
        },
      );
    } else {
      return Container(); // Return an empty container since number picker shouldn't be displayed
    }
  }

  Widget _renderPickerText(String title) {
    if (widget.showPicker) {
      return Text(
        title,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return createQuestionWidget();
  }
}
