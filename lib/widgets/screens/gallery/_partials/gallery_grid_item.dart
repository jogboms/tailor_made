import 'package:flutter/material.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/utils/mk_fade_in_route.dart';
import 'package:tailor_made/widgets/screens/gallery/_views/gallery_view.dart';

class GalleryGridItem extends StatelessWidget {
  const GalleryGridItem({
    Key key,
    this.image,
  }) : super(key: key);

  final ImageModel image;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: image.src,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(image.src),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push<dynamic>(
                mkFadeInRoute(
                  builder: (_) => GalleryView(image: image),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
