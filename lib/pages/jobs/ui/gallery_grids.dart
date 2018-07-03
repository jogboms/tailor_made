import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/gallery/gallery_view.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 70.0;

class FireImage {
  StorageReference ref;
  String imageUrl;
  bool isLoading = true;
  bool isSucess = false;
}

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

class GalleryGrids extends StatefulWidget {
  final Size gridSize;
  final ContactModel contact;
  final List<ImageModel> images;

  GalleryGrids({
    Key key,
    double gridSize,
    @required this.contact,
    @required this.images,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  @override
  GalleryGridsState createState() {
    return new GalleryGridsState();
  }
}

class GalleryGridsState extends State<GalleryGrids> {
  List<FireImage> fireImages = [];

  @override
  initState() {
    super.initState();
    fireImages = widget.images.map((img) => FireImage()..imageUrl = img.src);
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    List<Widget> imagesList = widget.images.map((img) {
      return GalleryGrid(
        imageUrl: img.src,
        tag: img.src,
        size: widget.gridSize.width,
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
              onPressed: () => TMNavigate(context, GalleryPage(images: widget.images), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: widget.gridSize.width + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [newGrid(widget.contact, widget.gridSize)]..addAll(imagesList),
          ),
        ),
      ],
    );
  }

  Widget newGrid(ContactModel contact, Size gridSize) {
    return new Container(
      width: gridSize.width,
      margin: EdgeInsets.only(right: 8.0),
      child: new Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: new InkWell(
          onTap: _handlePhotoButtonPressed,
          child: Icon(
            Icons.add_a_photo,
            size: 24.0,
            color: textBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }

  Future<Null> _handlePhotoButtonPressed() async {
    var source = await showChildDialog(
      context: context,
      child: new SimpleDialog(
        children: <Widget>[
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Padding(child: Text("Camera"), padding: EdgeInsets.all(8.0)),
          ),
          new SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Padding(child: Text("Gallery"), padding: EdgeInsets.all(8.0)),
          ),
        ],
      ),
    );
    if (source == null) return;
    var imageFile = await ImagePicker.pickImage(source: source);
    var random = new Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('references/image_$random.jpg');
    var uploadTask = ref.putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      var image = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..imageUrl = image;
      });
    } catch (e) {
      setState(() {
        fireImages.last.isLoading = false;
      });
    }
  }
}
