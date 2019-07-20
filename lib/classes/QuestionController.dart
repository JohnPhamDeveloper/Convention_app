import 'package:flutter/material.dart';

class QuestionController {
  int _currentQuestionIndex = 0;
  List<List<TextSpan>> _questions = new List<List<TextSpan>>();

  void incrementQuestionIndex() => _currentQuestionIndex++;

  void addQuestion(List<TextSpan> question) => _questions.add(question);

  void resetCurrentQuestionIndex() => _currentQuestionIndex = 0;

  int getQuestionsLength() => _questions.length;

  void clearQuestions() => _questions.clear();

  List<TextSpan> getQuestion(int index) {
    if (_questions.isEmpty || index < 0 || index >= _questions.length)
      return null;

    return _questions[_currentQuestionIndex];
  }

  List<TextSpan> getCurrentQuestion() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length)
      return _questions[_questions.length - 1];

    return _questions[_currentQuestionIndex];
  }

  int getCurrentQuestionIndex() {
    return _currentQuestionIndex;
  }
}
