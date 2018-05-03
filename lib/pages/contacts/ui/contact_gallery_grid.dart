import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery_grid_item.dart';

class GalleryGridWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      crossAxisSpacing: 1.5,
      mainAxisSpacing: 1.5,
      children: List.generate(40, (i) => GalleryGridItem()).toList(),
    );
  }
}
