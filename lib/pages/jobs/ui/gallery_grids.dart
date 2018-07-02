import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/gallery/gallery_view.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 70.0;

class GalleryGrid extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final Size size;
  final void Function(String imageUrl) onTapDelete;

  GalleryGrid({
    Key key,
    @required this.tag,
    @required this.imageUrl,
    this.onTapDelete,
    double size,
  })  : size = Size.square(size ?? _kGridWidth),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Hero(
      tag: tag,
      child: Container(
        width: size.width,
        margin: EdgeInsets.only(right: 8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: new Material(
                color: Colors.white,
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                child: new Ink.image(
                  image: new NetworkImage(imageUrl),
                  fit: BoxFit.cover,
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
                    },
                    child: onTapDelete != null
                        ? new Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () => onTapDelete(imageUrl),
                              child: new Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: new Icon(Icons.cancel, color: Colors.red),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GalleryGrids extends StatelessWidget {
  final Size gridSize;
  final List<ImageModel> images;

  GalleryGrids({
    Key key,
    double gridSize,
    @required this.images,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> imagesList = images.map((img) {
      return GalleryGrid(
        imageUrl: img.src,
        tag: img.src,
        size: gridSize.width,
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
              onPressed: () => TMNavigate(context, GalleryPage(images: images), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: gridSize.width + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [GalleryGrids.newGrid(gridSize)]..addAll(imagesList),
          ),
        ),
      ],
    );
  }

  static Widget newGrid(Size gridSize) {
    return new Container(
      width: gridSize.width,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: () {},
          child: Icon(
            Icons.add_a_photo,
            size: 24.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
