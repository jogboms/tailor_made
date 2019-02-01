import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/gallery/_partials/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({
    Key key,
    this.images,
  }) : super(key: key);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Gallery",
                  style: theme.appBarTitle,
                ),
                images != null
                    ? Text(
                        "${images.length} Photos",
                        style: theme.xsmall,
                      )
                    : const SizedBox(),
              ],
            ),
            backgroundColor: kAppBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: const MkBackButton(),
            brightness: Brightness.light,
            forceElevated: true,
            elevation: 1.0,
            centerTitle: false,
            floating: true,
          ),
          Builder(builder: (context) {
            if (images == null) {
              return StreamBuilder(
                stream: CloudDb.gallery.snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(
                      child: const MkLoadingSpinner(),
                    );
                  }
                  return _Content(
                    images: snapshot.data.documents
                        .map((item) => ImageModel.fromJson(item.data))
                        .toList(),
                  );
                },
              );
            }
            return _Content(images: images);
          }),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key key,
    @required this.images,
  }) : super(key: key);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SliverFillRemaining(
        child: const EmptyResultView(message: "No images available"),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0),
      sliver: GalleryGrid(images: images),
    );
  }
}
