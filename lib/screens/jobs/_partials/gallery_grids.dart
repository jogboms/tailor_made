import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/screens/gallery/gallery.dart';
import 'package:tailor_made/screens/jobs/_partials/gallery_grid_item.dart';
import 'package:tailor_made/services/gallery/gallery.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

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
  _GalleryGridsState createState() => _GalleryGridsState();
}

class _GalleryGridsState extends State<GalleryGrids> {
  List<FireImage> fireImages = [];

  @override
  void initState() {
    super.initState();
    fireImages = widget.job.images
        .map(
          (img) => FireImage()..image = img,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    final List<Widget> imagesList = List<Widget>.generate(
      fireImages.length,
      (int index) {
        final fireImage = fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return const Center(
            widthFactor: 2.5,
            child: MkLoadingSpinner(),
          );
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
                style: theme.small.copyWith(color: Colors.black87),
              ),
            ),
            MkClearButton(
              child: Text("SHOW ALL", style: theme.smallBtn),
              onPressed: () {
                MkNavigate(
                  context,
                  GalleryPage(images: widget.job.images),
                  fullscreenDialog: true,
                );
              },
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Container(
          height: widget.gridSize.width + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: [
              _NewGrid(
                gridSize: widget.gridSize,
                onPressed: _handlePhotoButtonPressed,
              )
            ]..addAll(imagesList.reversed.toList()),
          ),
        ),
      ],
    );
  }

  void _handlePhotoButtonPressed() async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    // TODO: remove firebase coupling
    final ref = Gallery.di().createFile(imageFile);

    setState(() {
      fireImages.add(FireImage()..ref = ref);
    });
    try {
      final imageUrl = (await ref.getDownloadURL()).downloadUrl?.toString();

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
          "images": fireImages.where((img) => img.image != null).map((img) => img.image.toMap()).toList(),
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

class _NewGrid extends StatelessWidget {
  const _NewGrid({
    Key key,
    @required this.gridSize,
    @required this.onPressed,
  }) : super(key: key);

  final Size gridSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: gridSize.width,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[100],
        child: InkWell(
          onTap: onPressed,
          child: Icon(
            Icons.add_a_photo,
            size: 24.0,
            color: kTextBaseColor.withOpacity(.35),
          ),
        ),
      ),
    );
  }
}
