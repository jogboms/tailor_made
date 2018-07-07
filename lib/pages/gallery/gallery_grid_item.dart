import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery_view.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';

class GalleryGridItem extends StatelessWidget {
  final ImageModel image;

  GalleryGridItem({
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
              PageRouteBuilder pageBuilder = new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => GalleryView(imageUrl: image.src),
                transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                  return new FadeTransition(opacity: animation, child: child);
                },
              );
              Navigator.of(context).push(pageBuilder);
            },
          ),
        ),
      ),
    );
  }
}
