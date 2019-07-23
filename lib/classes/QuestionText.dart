import 'package:flutter/material.dart';

class QuestionText {
  final List<TextSpan> questionText;
  final bool displayNumberPicker;
  final bool isSuccessQuestion;

  QuestionText(this.questionText, this.displayNumberPicker,
      {this.isSuccessQuestion: false});
}
