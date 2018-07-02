import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';
import 'package:tailor_made/pages/gallery/models/gallery_image.model.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class GalleryGridWidget extends StatelessWidget {
  final ContactModel contact;
  final List<JobModel> jobs;

  GalleryGridWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    final List<GalleryImageModel> images = [];

    jobs.forEach(
      (item) => images.addAll(
            item.images.map(
              (src) => GalleryImageModel(src: src),
            ),
          ),
    );

    if (images.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No images available"),
      );
    }

    return GalleryGrid(
      images: images.toList(),
    );
  }
}
