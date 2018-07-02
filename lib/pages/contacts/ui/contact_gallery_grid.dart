import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/gallery/models/gallery_image.model.dart';
import 'package:tailor_made/pages/gallery/gallery_grid.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';

class GalleryGridWidget extends StatelessWidget {
  final ContactModel contact;

  GalleryGridWidget({@required this.contact});

  @override
  build(BuildContext context) {
    print(contact.toMap());
    return StreamBuilder(
      stream: Cloudstore.jobs.where("contact.id", isEqualTo: contact.id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(
            child: loadingSpinner(),
          );
        }

        List<DocumentSnapshot> list = snapshot.data.documents;

        if (list.isEmpty) {
          return SliverFillRemaining(
            child: TMEmptyResult(message: "No images available"),
          );
        }

        final List<GalleryImageModel> images = [];

        final jobs = list.map((item) => JobModel.fromJson(item.data));

        jobs.forEach(
          (item) => images.addAll(
                item.images.map(
                  (src) => GalleryImageModel(src: src),
                ),
              ),
        );

        return GalleryGrid(
          images: images.toList(),
        );
      },
    );
  }
}
