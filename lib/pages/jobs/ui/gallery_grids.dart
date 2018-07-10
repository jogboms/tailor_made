import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/pages/gallery/gallery.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/jobs/ui/gallery_grid_item.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_image_choice_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

const _kGridWidth = 70.0;

class FireImage {
  StorageReference ref;
  ImageModel image;
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
    fireImages = widget.job.images.map((img) => FireImage()..image = img).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imagesList = List.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return Center(widthFactor: 2.5, child: loadingSpinner());
        }

        return GalleryGridItem(
          image: image,
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
            children: [newGrid(widget.gridSize)]..addAll(imagesList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  Widget newGrid(Size gridSize) {
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
    var source = await imageChoiceDialog(context: context);
    if (source == null) return;
    var imageFile = await ImagePicker.pickImage(source: source);
    var random = new Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref().child('references/image_$random.jpg');
    var uploadTask = ref.putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      var imageUrl = (await uploadTask.future).downloadUrl?.toString();
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true
          ..image = ImageModel(
            contactID: widget.job.contactID,
            src: imageUrl,
            path: ref.path,
          );

        widget.job.reference.updateData({
          "images": fireImages.map((img) => img.image.toMap()).toList(),
        });
      });
    } catch (e) {
      setState(() {
        fireImages.last.isLoading = false;
      });
    }
  }
}
