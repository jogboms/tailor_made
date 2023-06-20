import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';

import 'gallery_grid_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({super.key, required this.images});

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 1.5,
      mainAxisSpacing: 1.5,
      children: images.map((ImageModel image) => GalleryGridItem(image: image)).toList(),
    );
  }
}
