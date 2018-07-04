import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/pages/gallery/models/image.model.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grid_item.dart';
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

class GalleryGrids extends StatefulWidget {
  final Size gridSize;
  final JobModel job;

  GalleryGrids({
    Key key,
    double gridSize,
    @required this.job,
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
    fireImages = widget.job.images.map((img) => FireImage()..imageUrl = img.src).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imagesList = List.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.imageUrl;

        if (image == null) {
          return Center(widthFactor: 2.5, child: CircularProgressIndicator());
        }

        return GalleryGridItem(
          imageUrl: image,
          tag: "$image-$index",
          size: _kGridWidth,
          // Remove images from storage using path
          onTapDelete: fireImage.ref != null
              ? (image) {
                  setState(() {
                    fireImage.ref.delete();
                    fireImages.removeAt(index);
                  });
                }
              : null,
        );
      },
    ).toList();

    return new Column(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(child: Text("GALLERY", style: ralewayRegular(12.0, Colors.black87))),
            CupertinoButton(
              child: Text("SHOW ALL", style: ralewayRegular(11.0, textBaseColor)),
              onPressed: () => TMNavigate(context, GalleryPage(images: widget.job.images), fullscreenDialog: true),
            ),
          ],
        ),
        new Container(
          height: widget.gridSize.width + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [newGrid(widget.job.contact, widget.gridSize)]..addAll(imagesList.reversed.toList()),
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

        widget.job.reference.updateData({
          "images": fireImages
              .map((img) => ImageModel(
                    src: img.imageUrl,
                    path: ref.path,
                    contact: widget.job.contact,
                  ).toMap())
              .toList()
        });
      });
    } catch (e) {
      setState(() {
        fireImages.last.isLoading = false;
      });
    }
  }
}
