import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/LoginForm.dart';

class LoginScreen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomPaint(
              painter: ShapesPainter(),
              child: Container(height: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  LoginForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = Colors.cyanAccent;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    Path path = Path();
    path.lineTo(0, size.height - 500);
    path.lineTo(size.width, 0);
    // close the path to form a bounded shape
    path.close();
    canvas.drawPath(path, paint);

    final initDistance = size.width - 200;
    final initDistanceY = size.height - 550;

    canvas.drawCircle(Offset(initDistance + 50, initDistanceY), 20.0, paint);
    canvas.drawCircle(Offset(initDistance + 100, initDistanceY), 20.0, paint);
    canvas.drawCircle(Offset(initDistance + 150, initDistanceY), 20.0, paint);
    // canvas.drawCircle(Offset(size.width / 2, size.height + 260), 300.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
