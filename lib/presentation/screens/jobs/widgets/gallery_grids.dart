import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'gallery_grid_item.dart';
import 'image_form_value.dart';

class GalleryGrids extends StatefulWidget {
  const GalleryGrids({super.key, required this.job, required this.userId});

  final JobEntity job;
  final String userId;

  @override
  State<GalleryGrids> createState() => _GalleryGridsState();
}

class _GalleryGridsState extends State<GalleryGrids> {
  late final List<ImageFormValue> _images = <ImageFormValue>[
    ...widget.job.images.map(ImageModifyFormValue.new),
  ];

  @override
  void didUpdateWidget(covariant GalleryGrids oldWidget) {
    if (widget.job.images != oldWidget.job.images) {
      _images
        ..clear()
        ..addAll(widget.job.images.map(ImageModifyFormValue.new));
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(
              child: Text('GALLERY', style: theme.textTheme.bodySmall),
            ),
            AppClearButton(
              child: Text(
                'SHOW ALL',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: AppFontWeight.medium,
                  color: theme.colorScheme.secondary,
                ),
              ),
              onPressed: () {
                context.registry.get<GalleryCoordinator>().toGallery(widget.userId, widget.job.images.toList());
              },
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Container(
          height: GalleryGridItem.kGridWidth + 8,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              _NewGrid(onPressed: _handlePhotoButtonPressed),
              for (final ImageFormValue value in _images.reversed)
                GalleryGridItem.formValue(
                  value: value,
                  onTapDelete: _handleDeleteItem,
                )
            ],
          ),
        ),
      ],
    );
  }

  void _handleDeleteItem(ImageFormValue value) async {
    final ImageFileReference reference = switch (value) {
      ImageCreateFormValue(:final CreateImageData data) => (src: data.src, path: data.path),
      ImageModifyFormValue(:final ImageEntity data) => (src: data.src, path: data.path),
    };
    await context.registry.get<ImageStorage>().delete(reference: reference, userId: widget.userId);
    if (mounted) {
      setState(() {
        _images.remove(value);
      });
    }
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

    try {
      // TODO(Jogboms): move this out of here
      final ImageFileReference ref = await registry.get<ImageStorage>().createReferenceImage(
            path: imageFile.path,
            userId: widget.userId,
          );

      setState(() {
        _images.add(
          ImageCreateFormValue(
            CreateImageData(
              userID: widget.userId,
              contactID: widget.job.contactID,
              jobID: widget.job.id,
              src: ref.src,
              path: ref.path,
            ),
          ),
        );
      });

      await registry.get<Jobs>().update(
            widget.job.userID,
            reference: widget.job.reference,
            images: _images
                .map(
                  (ImageFormValue input) => switch (input) {
                    ImageCreateFormValue() => CreateImageOperation(data: input.data),
                    ImageModifyFormValue() => ModifyImageOperation(data: input.data),
                  },
                )
                .toList(growable: false),
          );
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
    }
  }
}

class _NewGrid extends StatelessWidget {
  const _NewGrid({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: GalleryGridItem.kGridWidth,
      margin: const EdgeInsets.only(right: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: colorScheme.outlineVariant,
        child: InkWell(
          onTap: onPressed,
          child: const Icon(Icons.add_a_photo),
        ),
      ),
    );
  }
}
