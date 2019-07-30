import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/native_shapes/CircularBox.dart';

class NotificationDot extends StatelessWidget {
  final Color innerColor;
  final double outerSize;
  final double innerSize;
  final bool disable;

  NotificationDot(
      {this.innerColor,
      this.outerSize = 30.0,
      this.innerSize = 30.0,
      this.disable = false});

  Widget render() {
    if (!disable) {
      return CircularBox(
        height: outerSize,
        width: outerSize,
        padding: EdgeInsets.all(2.0),
        child: CircularBox(
          backgroundColor: innerColor,
          height: innerSize,
          width: innerSize,
          child: Container(),
        ),
      );
    }

    return Container(width: 0, height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return render();
  }
}
