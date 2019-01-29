import 'package:flutter/material.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/widgets/screens/gallery/gallery_view.dart';

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
              final PageRouteBuilder pageBuilder = PageRouteBuilder<dynamic>(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    GalleryView(image: image),
                transitionsBuilder:
                    (_, Animation<double> animation, __, Widget child) {
                  return FadeTransition(opacity: animation, child: child);
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
