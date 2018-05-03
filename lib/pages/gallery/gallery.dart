import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'gallery_grid.dart';
import 'models/gallery_image.model.dart';

class GalleryPage extends StatelessWidget {
  final List<GalleryImageModel> images;

  GalleryPage({this.images});

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gallery"),
                Text("21 Photos", style: TextStyle(fontSize: 11.0, color: textBaseColor)),
              ],
            ),
            floating: true,
          ),
          GalleryGrid(images: images),
        ],
      ),
    );
  }
}
