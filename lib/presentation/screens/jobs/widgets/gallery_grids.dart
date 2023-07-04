import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../providers/job_provider.dart';
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
                context.router.toGallery(widget.userId, widget.job.images.toList());
              },
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, _) {
            final ImageStorageProvider storage = ref.read(imageStorageProvider);

            return Container(
              height: GalleryGridItem.kGridWidth + 8,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _NewGrid(onPressed: () => _handlePhotoButtonPressed(ref.read(jobProvider), storage)),
                  for (final ImageFormValue value in _images.reversed)
                    GalleryGridItem.formValue(
                      value: value,
                      onTapDelete: (ImageFormValue value) => _handleDeleteItem(storage, value),
                    )
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _handleDeleteItem(ImageStorageProvider storage, ImageFormValue value) async {
    final ImageFileReference reference = switch (value) {
      ImageCreateFormValue(:final CreateImageData data) => (src: data.src, path: data.path),
      ImageModifyFormValue(:final ImageEntity data) => (src: data.src, path: data.path),
    };
    await storage.delete(reference);
    if (mounted) {
      setState(() {
        _images.remove(value);
      });
    }
  }

  void _handlePhotoButtonPressed(JobProvider jobProvider, ImageStorageProvider storage) async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    final XFile? imageFile = await ImagePicker().pickImage(source: source);
    if (imageFile == null) {
      return;
    }

    try {
      final ImageFileReference ref = await storage.create(
        CreateImageType.reference,
        path: imageFile.path,
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

      await jobProvider.modifyGallery(reference: widget.job.reference, images: _images);
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
