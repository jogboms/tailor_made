import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key, this.images = const <ImageEntity>[], required this.userId});

  final List<ImageEntity> images;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Gallery', style: theme.appBarTitle),
                if (images.isEmpty) Text('${images.length} Photos', style: theme.xsmall),
              ],
            ),
            backgroundColor: kAppBarBackgroundColor,
            automaticallyImplyLeading: false,
            leading: const AppBackButton(),
            forceElevated: true,
            elevation: 1.0,
            centerTitle: false,
            floating: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          Builder(
            builder: (BuildContext context) {
              if (images.isNotEmpty) {
                return _Content(images: images);
              }

              return StreamBuilder<List<ImageEntity>>(
                // TODO(Jogboms): move this out of here
                stream: context.registry.get<Gallery>().fetchAll(userId),
                builder: (_, AsyncSnapshot<List<ImageEntity>> snapshot) {
                  final List<ImageEntity>? data = snapshot.data;
                  if (data == null) {
                    return const SliverFillRemaining(child: LoadingSpinner());
                  }
                  return _Content(images: data);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.images});

  final List<ImageEntity> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: 'No images available'));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0),
      sliver: GalleryGrid(images: images),
    );
  }
}
