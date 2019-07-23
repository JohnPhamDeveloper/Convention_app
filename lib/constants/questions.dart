import 'package:flutter/material.dart';
import 'package:cosplay_app/constants/constants.dart';

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

List<TextSpan> q4(BuildContext context) {
  return <TextSpan>[
    TextSpan(text: 'How '),
    TextSpan(text: 'long '),
    TextSpan(
      text: 'have you been a ',
    ),
    TextSpan(
      text: 'photographer',
      style: kTextStyleImportant(context),
    ),
    TextSpan(
      text: '?',
    ),
  ];
}

List<TextSpan> success(BuildContext context) {
  return <TextSpan>[
    TextSpan(text: 'Your profile is ready to go!'),
  ];
}
