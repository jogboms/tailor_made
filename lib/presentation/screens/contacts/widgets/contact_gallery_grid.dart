import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../gallery/widgets/gallery_grid.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({super.key, required this.contact, required this.jobs});

  final ContactModel? contact;
  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    final List<ImageModel> images = jobs.fold<List<ImageModel>>(
      <ImageModel>[],
      (List<ImageModel> acc, JobModel item) => acc..addAll(item.images),
    );

    if (images.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: 'No images available'));
    }

    return GalleryGrid(images: images.toList());
  }
}
