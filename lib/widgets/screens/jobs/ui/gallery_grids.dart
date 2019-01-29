import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/services/cloud_storage.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/gallery/gallery.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/gallery_grid_item.dart';

const _kGridWidth = 70.0;

class FireImage {
  StorageReference ref;
  ImageModel image;
  bool isLoading = true;
  bool isSucess = false;
}

class GalleryGrids extends StatefulWidget {
  GalleryGrids({
    Key key,
    double gridSize,
    @required this.job,
  })  : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  final Size gridSize;
  final JobModel job;

  @override
  GalleryGridsState createState() {
    return GalleryGridsState();
  }
}

class GalleryGridsState extends State<GalleryGrids> {
  List<FireImage> fireImages = [];

  @override
  void initState() {
    super.initState();
    fireImages =
        widget.job.images.map((img) => FireImage()..image = img).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> imagesList = List<Widget>.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return Center(widthFactor: 2.5, child: const MkLoadingSpinner());
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

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                "GALLERY",
                style: mkFontRegular(12.0, Colors.black87),
              ),
            ),
            CupertinoButton(
              child: Text(
                "SHOW ALL",
                style: mkFontRegular(11.0, Colors.black),
              ),
              onPressed: () => MkNavigate(
                  context, GalleryPage(images: widget.job.images),
                  fullscreenDialog: true),
            ),
          ],
        ),
        Container(
          height: widget.gridSize.width + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [newGrid(widget.gridSize)]
              ..addAll(imagesList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  Widget newGrid(Size gridSize) {
    return Container(
      width: gridSize.width,
      margin: EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: InkWell(
          onTap: _handlePhotoButtonPressed,
          child: Icon(
            Icons.add_a_photo,
            size: 24.0,
            color: kTextBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }

  Future<Null> _handlePhotoButtonPressed() async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    final ref = CloudStorage.createReferenceImage();
    final uploadTask = ref.putFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      final imageUrl = (await uploadTask.future).downloadUrl?.toString();

      setState(() {
        fireImages.last.image = ImageModel(
          contactID: widget.job.contactID,
          jobID: widget.job.id,
          src: imageUrl,
          path: ref.path,
        );
      });

      await widget.job.reference.updateData(
        <String, List<Map<String, dynamic>>>{
          "images": fireImages
              .where((img) => img.image != null)
              .map((img) => img.image.toMap())
              .toList(),
        },
      );

      // Redraw
      setState(() {
        fireImages.last
          ..isLoading = false
          ..isSucess = true;
      });
    } catch (e) {
      setState(() {
        fireImages.last.isLoading = false;
      });
    }
  }
}
