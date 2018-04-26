import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/ui/blank.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

const _kGridWidth = 70.0;

class GalleryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: _kGridWidth,
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          fit: BoxFit.cover,
          image: new NetworkImage("https://placeimg.com/640/640/nature"),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: new Material(
        elevation: 2.0,
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
            Text("Gallery", style: theme.titleStyle),
            FlatButton(
              child: Text("SHOW ALL", style: TextStyle(fontSize: 11.0)),
              onPressed: () => TMNavigate(context, BlankPage(), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: _kGridWidth + 16,
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
