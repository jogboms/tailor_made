import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({super.key, required this.image});

  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image.src,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image.src)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(onTap: () => context.registry.get<GalleryCoordinator>().toImage(image)),
        ),
      ),
    );
  }
}
