import 'package:flutter/material.dart';

class PainterBall extends CustomPainter {
  PainterBall();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.cyanAccent;

    final double initDistance = size.width - 200.0;
    final double initDistanceY = size.height - 550.0;

    canvas.drawCircle(Offset(initDistance + 50.0, initDistanceY), 20.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
