import 'package:flutter/material.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_theme.dart';

import 'gallery_grid.dart';
import 'models/gallery_image.model.dart';

class GalleryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<GalleryImageModel> images = List
        .generate(
          40,
          (int index) => GalleryImageModel(src: "https://placeimg.com/640/640/people/$index"),
//            (int) => GalleryImageModel(src: "https://source.unsplash.com/100x100?people"),
        )
        .toList();

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
            automaticallyImplyLeading: false,
            leading: backButton(context),
            centerTitle: false,
            floating: true,
          ),
          GalleryGrid(images: images),
        ],
      ),
    );
  }
}
