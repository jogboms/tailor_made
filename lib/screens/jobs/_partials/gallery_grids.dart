import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/coordinator/gallery_coordinator.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/screens/jobs/_partials/gallery_grid_item.dart';
import 'package:tailor_made/services/gallery/gallery.dart';
import 'package:tailor_made/utils/ui/mk_image_choice_dialog.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class GalleryGrids extends StatefulWidget {
  GalleryGrids({Key key, double gridSize, @required this.job})
      : gridSize = Size.square(gridSize ?? _kGridWidth),
        super(key: key);

  final Size gridSize;
  final JobModel job;

  @override
  _GalleryGridsState createState() => _GalleryGridsState();
}

class _GalleryGridsState extends State<GalleryGrids> {
  List<_FireImage> _fireImages = [];

  @override
  void initState() {
    super.initState();
    _fireImages = widget.job.images.map((img) => _FireImage()..image = img).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    final List<Widget> imagesList = List<Widget>.generate(
      _fireImages.length,
      (int index) {
        final fireImage = _fireImages[index];
        final image = fireImage.image;

        if (image == null) {
          return const Center(widthFactor: 2.5, child: MkLoadingSpinner());
        }

        return GalleryGridItem(
          image: image,
          tag: "$image-$index",
          size: _kGridWidth,
          // Remove images from storage using path
          onTapDelete: fireImage.ref != null
              ? (image) => setState(() {
                    fireImage.ref.delete();
                    _fireImages.removeAt(index);
                  })
              : null,
        );
      },
    ).reversed.toList();

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text("GALLERY", style: theme.small.copyWith(color: Colors.black87)),
            ),
            MkClearButton(
              child: Text("SHOW ALL", style: theme.smallBtn),
              onPressed: () => GalleryCoordinator.di().toGallery(widget.job.images.toList()),
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
              _NewGrid(gridSize: widget.gridSize, onPressed: _handlePhotoButtonPressed),
              ...imagesList,
            ],
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
    final ref = Gallery.di().createFile(imageFile);

    setState(() {
      _fireImages.add(_FireImage()..ref = ref);
    });
    try {
      final imageUrl = (await ref.getDownloadURL()).downloadUrl?.toString();

      setState(() {
        _fireImages.last.image = ImageModel(
          (b) => b
            ..contactID = widget.job.contactID
            ..jobID = widget.job.id
            ..src = imageUrl
            ..path = ref.path,
        );
      });

      await widget.job.reference.updateData(
        <String, List<Map<String, dynamic>>>{
          "images": _fireImages.where((img) => img.image != null).map((img) => img.image.toMap()).toList(),
        },
      );

      setState(() {
        _fireImages.last
          ..isLoading = false
          ..isSucess = true;
      });
    } catch (e) {
      setState(() {
        _fireImages.last.isLoading = false;
      });
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({Key key, @required this.gridSize, @required this.onPressed}) : super(key: key);

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
          child: Icon(Icons.add_a_photo, size: 24.0, color: kTextBaseColor.withOpacity(.35)),
        ),
      ),
    );
  }
}

const _kGridWidth = 70.0;

class _FireImage {
  Storage ref;
  ImageModel image;
  bool isLoading = true;
  bool isSucess = false;
}
