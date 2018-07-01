import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/gallery/gallery_view.dart';

const _kGridWidth = 70.0;

class GalleryGrid extends StatelessWidget {
  final String tag;
  final String imageUrl;

  GalleryGrid({
    Key key,
    @required this.tag,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Hero(
      tag: tag,
      child: Container(
        width: _kGridWidth,
        margin: EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(imageUrl),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: new Material(
          elevation: 2.0,
          color: Colors.transparent,
          child: new InkWell(
            onTap: () {
              Navigator.of(context).push(
                    new PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) => GalleryView(imageUrl, tag),
                      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                        return new FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
              // TMNavigate(context, GalleryView(image, "-$image-$id-$id2"), fullscreenDialog: true)
            },
          ),
        ),
      ),
    );
  }
}

class GalleryGrids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> imagesList = List.generate(10, (int index) {
      Random rand = new Random();
      int id = rand.nextInt(10000);
      int id2 = rand.nextInt(10000);
      String image = "https://placeimg.com/640/640/nature/$id";

      return GalleryGrid(
        imageUrl: image,
        tag: "$image-$id-$id2",
      );
    }).toList();
    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Gallery", style: theme.titleStyle),
            ),
            CupertinoButton(
              child: Text("SHOW ALL", style: ralewayRegular(11.0, textBaseColor)),
              onPressed: () => TMNavigate(context, GalleryPage(), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: _kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [GalleryGrids.newGrid()]..addAll(imagesList),
          ),
        ),
      ],
    );
  }

  static Widget newGrid() {
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () {},
          child: Icon(
            Icons.add_circle,
            size: 24.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
