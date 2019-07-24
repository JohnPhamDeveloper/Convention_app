import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final TextStyle style =
      TextStyle(fontWeight: FontWeight.w400, fontSize: 22.0);
  final Function onTap;
  final String title;

  NavButton({@required this.title, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              child: Text(
                title,
                style: style,
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
