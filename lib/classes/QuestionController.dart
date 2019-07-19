import 'package:flutter/material.dart';

class QuestionController {
  int _currentQuestionIndex = 0;
  List<List<TextSpan>> _questions = new List<List<TextSpan>>();

  void incrementQuestionIndex() {
    _currentQuestionIndex++;
  }

  void addQuestion(List<TextSpan> question) {
    _questions.add(question);
  }

  void resetCurrentQuestionIndex() {
    _currentQuestionIndex = 0;
  }

  void clearQuestions() {
    _questions.clear();
  }

  List<TextSpan> getQuestion() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return _questions[_questions.length - 1];
    } else {
      return _questions[_currentQuestionIndex];
    }
  }

  int getCurrentQuestionIndex() {
    return _currentQuestionIndex;
  }
}
