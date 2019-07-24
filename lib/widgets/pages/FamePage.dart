import 'package:flutter/material.dart';

class FamePage extends StatefulWidget {
  @override
  _FamePageState createState() => _FamePageState();
}

class _FamePageState extends State<FamePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("14125",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 40.0,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 10.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(30, 0, 0, 0),
                        )
                      ])),
              Text(
                "Fame tokens",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        SizedBox(height: 20.0),
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: ListView(
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  ProductItem(),
                  ProductItem(),
                  ProductItem(),
                  ProductItem(),
                ],
              ),
            ],
          ),
        ),
      ],
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
