import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:uuid/uuid.dart';

import 'gallery_grid_item.dart';

class GalleryGrids extends StatefulWidget {
  GalleryGrids({super.key, double? gridSize, required this.job, required this.userId})
      : gridSize = Size.square(gridSize ?? _kGridWidth);

  final Size gridSize;
  final JobEntity job;
  final String userId;

  @override
  State<GalleryGrids> createState() => _GalleryGridsState();
}

class _GalleryGridsState extends State<GalleryGrids> {
  List<_FireImage> _fireImages = <_FireImage>[];

  @override
  void initState() {
    super.initState();
    _fireImages = widget.job.images.map((ImageEntity img) => _FireImage()..image = img).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    final List<Widget> imagesList = List<Widget>.generate(
      _fireImages.length,
      (int index) {
        final _FireImage fireImage = _fireImages[index];
        final ImageEntity? image = fireImage.image;

        if (image == null) {
          return const Center(widthFactor: 2.5, child: LoadingSpinner());
        }

        return GalleryGridItem(
          image: image,
          tag: '$image-$index',
          size: _kGridWidth,
          // Remove images from storage using path
          onTapDelete: fireImage.ref != null
              ? (ImageEntity image) => setState(() {
                    fireImage.ref!.delete();
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
              child: Text('GALLERY', style: theme.small.copyWith(color: Colors.black87)),
            ),
            AppClearButton(
              child: Text('SHOW ALL', style: theme.smallBtn),
              onPressed: () {
                context.registry.get<GalleryCoordinator>().toGallery(widget.userId, widget.job.images.toList());
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
            children: <Widget>[
              _NewGrid(gridSize: widget.gridSize, onPressed: _handlePhotoButtonPressed),
              ...imagesList,
            ],
          ),
        ),
      ],
    );
  }

  void _handlePhotoButtonPressed() async {
    final Registry registry = context.registry;
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }
    // TODO(Jogboms): move this out of here
    final Storage ref = registry.get<Gallery>().createFile(File(imageFile.path), widget.userId)!;

    setState(() => _fireImages.add(_FireImage()..ref = ref));
    try {
      final String imageUrl = await ref.getDownloadURL();

      setState(() {
        final String id = const Uuid().v4();
        _fireImages.last.image = ImageEntity(
          reference: ReferenceEntity(
            id: id,
            path: id, // TODO
          ),
          id: id,
          userID: widget.userId,
          contactID: widget.job.contactID,
          jobID: widget.job.id,
          src: imageUrl,
          path: ref.path,
          createdAt: DateTime.now(),
        );
      });
      await registry.get<Jobs>().update(
            widget.job.userID,
            reference: widget.job.reference,
            images: _fireImages.map((_FireImage img) => img.image).whereType<ImageEntity>().toList(growable: false),
          );
      setState(() {
        _fireImages.last
          ..isLoading = false
          ..isSucess = true;
      });
    } catch (e) {
      setState(() => _fireImages.last.isLoading = false);
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({required this.gridSize, required this.onPressed});

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

const double _kGridWidth = 70.0;

class _FireImage {
  Storage? ref;
  ImageEntity? image;
  bool isLoading = true;
  bool isSucess = false;
}
