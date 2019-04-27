import 'package:flutter/material.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/screens/gallery/_partials/gallery_grid.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';

class GalleryGridWidget extends StatelessWidget {
  const GalleryGridWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  final ContactModel contact;
  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    final List<ImageModel> images = [];

    jobs.forEach(
      (item) => images.addAll(item.images),
    );

    if (images.isEmpty) {
      return SliverFillRemaining(
        child: const EmptyResultView(message: "No images available"),
      );
    }

    return GalleryGrid(images: images.toList());
  }
}
