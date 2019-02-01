import 'package:flutter/material.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/widgets/screens/gallery/_partials/gallery_grid_item.dart';

class GalleryGrid extends StatelessWidget {
  const GalleryGrid({
    Key key,
    this.images,
  }) : super(key: key);

  final List<ImageModel> images;

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
