import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String path;
  final double borderRadius;
  final double size;

  ImageContainer(
      {@required this.path, this.borderRadius = 0.0, this.size = 300.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                1.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(path),
          ),
        ),
      ),
    );
  }
}
