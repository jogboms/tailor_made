import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class GalleryGridWidget extends StatelessWidget {
  final ContactModel contact;
  final List<JobModel> jobs;

  const GalleryGridWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ImageModel> images = [];

    jobs.forEach(
      (item) => images.addAll(item.images),
    );

    if (images.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No images available"),
      );
    }

    return GalleryGrid(images: images.toList());
  }
}
