import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/gallery_coordinator.dart';
import 'package:tailor_made/models/image.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({Key key, this.image}) : super(key: key);

  final ImageModel image;

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
          child: InkWell(onTap: () => GalleryCoordinator.di().toImage(image)),
        ),
      ),
    );
  }
}
