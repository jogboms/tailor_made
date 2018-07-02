import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';
import 'package:tailor_made/pages/gallery/models/gallery_image.model.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class GalleryPage extends StatelessWidget {
  final List<String> images;

  GalleryPage({
    Key key,
    @required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<GalleryImageModel> imagesList = images.map((src) {
      return GalleryImageModel(src: src);
    }).toList();

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gallery", style: theme.appBarStyle),
                Text("${imagesList.length} Photos", style: TextStyle(fontSize: 11.0, color: textBaseColor)),
              ],
            ),
            backgroundColor: theme.appBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: backButton(context),
            centerTitle: false,
            floating: true,
          ),
          GalleryGrid(images: imagesList),
        ],
      ),
    );
  }
}
