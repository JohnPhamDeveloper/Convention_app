import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String path;
  final double borderRadius;
  final double width;
  final double height;

  ImageContainer(
      {@required this.path,
      this.borderRadius = 0.0,
      this.width = 300,
      this.height = 300});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
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
