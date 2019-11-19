import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/screens/gallery/_partials/gallery_grid.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({Key key, this.images}) : super(key: key);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Gallery", style: theme.appBarTitle),
                if (images != null) Text("${images.length} Photos", style: theme.xsmall),
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
                stream: Dependencies.di().gallery.fetchAll(Dependencies.di().session.user.getId()),
                builder: (_, AsyncSnapshot<List<ImageModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverFillRemaining(child: MkLoadingSpinner());
                  }
                  return _Content(images: snapshot.data);
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
  const _Content({Key key, @required this.images}) : super(key: key);

  final List<ImageModel> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: "No images available"));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 3.0),
      sliver: GalleryGrid(images: images),
    );
  }
}
