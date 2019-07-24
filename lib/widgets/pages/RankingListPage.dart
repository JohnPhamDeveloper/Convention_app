import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ScrollableTitle.dart';
import 'package:cosplay_app/constants/constants.dart';

class RankingListPage extends StatefulWidget {
  @override
  _RankingListPageState createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20),
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
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
