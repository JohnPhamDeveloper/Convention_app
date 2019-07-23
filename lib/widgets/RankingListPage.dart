import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';

class RankingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ScrollableTitle(
          title: Text("Most Friendly", style: kCardTitleStyle),
        ),
        SizedBox(height: kCardGap + 10),
        ScrollableTitle(
          title: Text("Highest Fame", style: kCardTitleStyle),
        ),
        SizedBox(height: kCardGap + 10),
        ScrollableTitle(
          title: Text("Most Daily Selfies", style: kCardTitleStyle),
        ),
      ],
    );
  }
}
