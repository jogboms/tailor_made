import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

const _kGridWidth = 70.0;

class GalleryView extends StatelessWidget {
  final String image;
  final String id;

  GalleryView(this.image, this.id);

  @override
  Widget build(BuildContext context) {
    print(id);
    return new Scaffold(
      body: Container(
        color: Colors.black,
        child: new SafeArea(
          child: Stack(
            children: [
              new Center(
                child: new Hero(
                  tag: image,
                  child: new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(image),
                  ),
                ),
              ),
              new Align(
                alignment: Alignment.topLeft,
                child: new Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: new IconButton(
                    color: Colors.white,
                    onPressed: () => Navigator.maybePop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GalleryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Random rand = new Random();
    int id = rand.nextInt(10000);
    int id2 = rand.nextInt(10000);
    const image = "https://placeimg.com/640/640/nature";
    return new Hero(
      tag: "-$image-$id-$id2",
      child: Container(
        width: _kGridWidth,
        margin: EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(image),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: new Material(
          elevation: 2.0,
          color: Colors.transparent,
          child: new InkWell(
            onTap: () => TMNavigate(context, GalleryView(image, "-$image-$id-$id2"), fullscreenDialog: true),
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
    List<Widget> imagesList = List
        .generate(
          10,
          (int index) => GalleryGrid(),
        )
        .toList();
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
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
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
