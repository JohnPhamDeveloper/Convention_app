import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/MyNavbar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MyNavbar(
          context: context,
        ),
      ],
    );
  }
}
