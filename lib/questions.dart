import 'package:flutter/material.dart';
import 'constants.dart';

List<TextSpan> q1(BuildContext context) {
  return <TextSpan>[
    TextSpan(text: 'Are you a '),
    TextSpan(
      text: 'cosplayer',
      style: kTextStyleImportant(context),
    ),
    TextSpan(
      text: '?',
    ),
  ];
}

List<TextSpan> q2(BuildContext context) {
  return <TextSpan>[
    TextSpan(text: 'Are you a '),
    TextSpan(
      text: 'photographer',
      style: kTextStyleImportant(context),
    ),
    TextSpan(
      text: '?',
    ),
  ];
}

List<TextSpan> q3(BuildContext context) {
  return <TextSpan>[
    TextSpan(text: 'How '),
    TextSpan(text: 'long '),
    TextSpan(
      text: 'have you been ',
    ),
    TextSpan(
      text: 'cosplaying',
      style: kTextStyleImportant(context),
    ),
    TextSpan(
      text: '?',
    ),
  ];
}
