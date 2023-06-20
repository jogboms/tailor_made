import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key, this.images, required this.userId});

  final List<ImageModel>? images;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Gallery', style: theme.appBarTitle),
                if (images != null) Text('${images!.length} Photos', style: theme.xsmall),
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
              if (images case final List<ImageModel> images) {
                return _Content(images: images);
              }

              return StreamBuilder<List<ImageModel>>(
                // TODO(Jogboms): move this out of here
                stream: context.registry.get<Gallery>().fetchAll(userId),
                builder: (_, AsyncSnapshot<List<ImageModel>> snapshot) {
                  final List<ImageModel>? data = snapshot.data;
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

  final List<ImageModel> images;

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