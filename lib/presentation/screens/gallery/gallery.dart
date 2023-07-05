import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/screens/gallery/providers/gallery_provider.dart';

import 'widgets/gallery_grid.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key, this.images = const <ImageEntity>[], required this.userId});

  final List<ImageEntity> images;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final L10n l10n = context.l10n;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(l10n.galleryPageTitle),
                if (images.isNotEmpty)
                  Text(
                    l10n.photosCaption(images.length),
                    style: theme.textTheme.labelSmall,
                  ),
              ],
            ),
            automaticallyImplyLeading: false,
            leading: const AppBackButton(),
            centerTitle: false,
            floating: true,
          ),
          Builder(
            builder: (BuildContext context) {
              if (images.isNotEmpty) {
                return _Content(images: images);
              }

              return Consumer(
                builder: (_, WidgetRef ref, Widget? child) => ref.watch(galleryProvider).when(
                      skipLoadingOnReload: true,
                      data: (List<ImageEntity> data) => _Content(images: data),
                      error: (Object error, StackTrace stackTrace) => SliverFillRemaining(
                        child: ErrorView(error, stackTrace),
                      ),
                      loading: () => child!,
                    ),
                child: const SliverFillRemaining(child: LoadingSpinner()),
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
      return SliverFillRemaining(child: EmptyResultView(message: context.l10n.noImagesAvailableMessage));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0),
      sliver: GalleryGrid(images: images),
    );
  }
}
