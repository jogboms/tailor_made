import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/pages/gallery/gallery_grid_item.dart';

class Gallery extends StatelessWidget {
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
          SliverGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1.5,
            mainAxisSpacing: 1.5,
            children: List.generate(40, (i) => GalleryGridItem()).toList(),
          ),
        ],
      ),
    );
  }
}
