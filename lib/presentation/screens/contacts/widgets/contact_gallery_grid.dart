import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../gallery/widgets/gallery_grid.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key, required this.jobs});

  final List<JobEntity> jobs;

  @override
  Widget build(BuildContext context) {
    final List<ImageEntity> images = jobs.fold<List<ImageEntity>>(
      <ImageEntity>[],
      (List<ImageEntity> acc, JobEntity item) => acc..addAll(item.images),
    );

    if (images.isEmpty) {
      return SliverFillRemaining(child: EmptyResultView(message: context.l10n.noImagesAvailableMessage));
    }

    return GalleryGrid(images: images.toList());
  }
}
