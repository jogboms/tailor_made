import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/models/gallery_image.model.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';

class GalleryGridWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    return GalleryGrid(
      images: List
          .generate(
            40,
            (int) => GalleryImageModel(src: "https://placeimg.com/640/640/tech"),
          )
          .toList(),
    );
  }
}
