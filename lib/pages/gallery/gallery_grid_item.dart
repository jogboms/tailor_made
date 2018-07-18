import 'package:flutter/material.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/pages/gallery/gallery_view.dart';

class GalleryGridItem extends StatelessWidget {
  final ImageModel image;

  const GalleryGridItem({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Hero(
      tag: image.src,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(image.src),
          ),
        ),
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            onTap: () {
              final PageRouteBuilder pageBuilder =
                  new PageRouteBuilder<dynamic>(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    GalleryView(image: image),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(opacity: animation, child: child);
                },
              );
              Navigator.of(context).push<dynamic>(pageBuilder);
            },
          ),
        ),
      ),
    );
  }
}
