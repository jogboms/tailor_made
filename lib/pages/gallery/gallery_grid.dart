import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery_grid_item.dart';
import 'package:tailor_made/models/image.dart';

class GalleryGrid extends StatelessWidget {
  final List<ImageModel> images;

  GalleryGrid({
    Key key,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 1.5,
      mainAxisSpacing: 1.5,
      children: images.map((image) => GalleryGridItem(image: image)).toList(),
    );
  }
}
