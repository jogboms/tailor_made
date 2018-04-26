import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class GalleryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: 100.0,
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: new NetworkImage("https://placeimg.com/640/640/nature"),
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: new Material(
        color: Colors.transparent,
        child: new InkWell(
          onTap: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
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
              padding: const EdgeInsets.all(8.0),
              child: Text("Gallery", style: theme.titleStyle),
            ),
            FlatButton(
              padding: const EdgeInsets.all(8.0),
              child: Text("SHOW ALL"),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          padding: const EdgeInsets.all(8.0),
          height: 120.0,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: [GalleryGrids.newGrid()]..addAll(imagesList),
          ),
        ),
      ],
    );
  }

  static Widget newGrid() {
    return new Container(
      width: 100.0,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () {},
          child: Icon(
            Icons.add_circle_outline,
            size: 30.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
