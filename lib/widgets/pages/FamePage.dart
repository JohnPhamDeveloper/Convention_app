import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cosplay_app/classes/FirestoreManager.dart';
import 'package:cosplay_app/classes/LoggedInUser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Column(
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
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        // crossAxisAlignment: CrossAxisAlignment.baseline,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Fame tokens",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: 5.0),
                          Icon(FontAwesomeIcons.questionCircle,
                              size: 20.0, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Fame items to purchase
            Expanded(
              child: ListView(
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      ProductItem(productName: "Uncommon Border", cost: "500"),
                      ProductItem(productName: "Rare Border", cost: "1000"),
                      ProductItem(
                          productName: "Legendary Border", cost: "2000"),
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
  String productName;
  String cost;

  ProductItem({@required this.cost, @required this.productName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        color: Colors.white,
        elevation: 5.0,
        child: InkWell(
          onTap: () {
            print("Product click");
          },
          child: Container(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    productName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 10.0),
                // Star and cost price
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.pinkAccent,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      cost,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
