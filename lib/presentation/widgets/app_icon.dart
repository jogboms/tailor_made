import 'package:flutter/material.dart';

import '../constants/app_images.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, this.heroTag, this.size = const Size.square(56), this.backgroundColor});

  final Size size;
  final String? heroTag;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) => Hero(
        tag: heroTag ?? 'TheAmazingAppIcon',
        child: Container(
          constraints: BoxConstraints.tight(size),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(size.shortestSide / 4),
          ),
          child: const Image(image: AppImages.logo, fit: BoxFit.contain),
        ),
      );
}
