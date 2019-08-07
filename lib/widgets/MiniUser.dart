import 'package:flutter/material.dart';
import 'package:cosplay_app/widgets/ImageContainer.dart';
import 'package:cosplay_app/constants/constants.dart';

class MiniUser extends StatelessWidget {
  final String imageHeroName;
  final bool enableSelfieDot;
  final bool enableStatusDot;
  final int rarity;
  final String imageURL;
  final double width;
  final double height;

  MiniUser(
      {this.imageHeroName,
      this.width = 300.0,
      this.height = 300.0,
      this.enableSelfieDot = true,
      this.enableStatusDot = true,
      this.rarity = 0,
      this.imageURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: ImageContainer(
        width: width,
        height: height,
        enableStatusDot: false,
        enableSelfieDot: enableSelfieDot,
        selfieDotInnerColor: Colors.pinkAccent,
        selfieDotLeft: 0,
        selfieDotBottom: 2,
        statusDotBottom: 2,
        statusDotRight: 2,
        borderWidth: 2.5,
        rarityBorderColor: kRarityBorders[rarity],
        borderRadius: 500.0,
        imageURL: imageURL,
      ),
    );
  }
}
