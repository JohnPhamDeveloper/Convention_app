import 'package:flutter/material.dart';
import 'package:cosplay_app/classes/QuestionText.dart';

class QuestionBank {
  int _currentQuestionIndex = 0;
  List<QuestionText> _questions = new List<QuestionText>();

  void incrementQuestionIndex() => _currentQuestionIndex++;

  void addQuestion(QuestionText question) => _questions.add(question);

  void resetCurrentQuestionIndex() => _currentQuestionIndex = 0;

  int getQuestionsLength() => _questions.length;

  void clearQuestions() => _questions.clear();

  QuestionText getQuestion(int index) {
    if (_questions.isEmpty || index < 0 || index >= _questions.length)
      return null;

    return _questions[index];
  }

  QuestionText getCurrentQuestion() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length)
      return _questions[_questions.length - 1];

    return _questions[_currentQuestionIndex];
  }

  int getCurrentQuestionIndex() {
    return _currentQuestionIndex;
  }
}
