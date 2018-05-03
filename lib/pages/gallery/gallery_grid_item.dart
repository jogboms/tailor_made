import 'dart:math';

import 'package:flutter/material.dart';
import 'gallery_view.dart';

class GalleryGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    int id = rand.nextInt(10000);
    int id2 = rand.nextInt(10000);
    const image = "https://placeimg.com/640/640/tech";
    return new Hero(
      tag: "-$image-$id-$id2",
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(image),
          ),
        ),
        child: new Material(
          color: Colors.transparent,
          child: new InkWell(
            onTap: () {
              PageRouteBuilder pageBuilder = new PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => GalleryView(image, "-$image-$id-$id2"),
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
