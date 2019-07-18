import 'package:flutter/material.dart';
import 'package:cosplay_app/constants.dart';
import 'package:cosplay_app/widgets/RoundButton.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;
  List<List<TextSpan>> questions = new List<List<TextSpan>>();

  @override
  void initState() {
    super.initState();
  }

  void initQuestions(context) {
    questions.clear();
    final q1 = <TextSpan>[
      TextSpan(text: 'Are you a '),
      TextSpan(
        text: 'Cosplayer',
        style: kTextStyleImportant(context),
      ),
      TextSpan(
        text: '?',
      ),
    ];
    questions.add(q1);
    final q2 = <TextSpan>[
      TextSpan(text: 'Are you a '),
      TextSpan(
        text: 'Photographer',
        style: kTextStyleImportant(context),
      ),
      TextSpan(
        text: '?',
      ),
    ];
    questions.add(q2);
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
      if (currentQuestionIndex < questions.length) {
        currentQuestionIndex++;
      }
    });
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
                      children: getQuestion(currentQuestionIndex),
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
            ],
          ),
        ),
      ),
    );
  }
}
