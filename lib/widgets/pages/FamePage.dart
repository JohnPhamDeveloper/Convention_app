import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';

class FamePage extends StatefulWidget {
  @override
  _FamePageState createState() => _FamePageState();
}

class _FamePageState extends State<FamePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<LoggedInUser>(
      builder: (context, loggedInUser, child) {
        return Column(
          children: <Widget>[
            // Fame point display
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      loggedInUser.getHashMap[FirestoreManager.keyFame]
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 40.0,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 5.0),
                              blurRadius: 10.0,
                              color: Color.fromARGB(30, 0, 0, 0),
                            )
                          ])),
                  Text(
                    "Fame tokens",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Fame items to purchase
            Expanded(
              child: ListView(
                children: <Widget>[
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      ProductItem(),
                      ProductItem(),
                      ProductItem(),
                      ProductItem(),
                      SizedBox(height: 400.0),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.orange,
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          print("Product click");
        },
        child: Container(width: 170, height: 290),
      ),
    );
  }
}
