import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';

class SelfieSection extends StatelessWidget {
  _imageContainerWrap(double width) {
    return ImageContainer(
        width: width,
        height: width,
        imageURL: 'https://c.pxhere.com/photos/5e/e8/portrait_people_anime_cute_girl_face_35mm_comic-507487.jpg!d');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Wrap(
      runSpacing: 2.0,
      spacing: 2.0,
      children: <Widget>[
        _imageContainerWrap(width),
        _imageContainerWrap(width),
        _imageContainerWrap(width),
        _imageContainerWrap(width),
      ],
    );
  }
}
