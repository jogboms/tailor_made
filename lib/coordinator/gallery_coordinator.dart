import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/screens/gallery/_views/gallery_view.dart';
import 'package:tailor_made/screens/gallery/gallery.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class GalleryCoordinator extends CoordinatorBase {
  const GalleryCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toImage(ImageModel image) {
    navigator?.push<void>(MkNavigate.fadeIn(GalleryView(image: image)));
  }

  void toGallery([List<ImageModel> images]) {
    navigator?.push<void>(
      images == null
          ? MkNavigate.slideIn(GalleryPage())
          : MkNavigate.slideIn(GalleryPage(images: images), fullscreenDialog: true),
    );
  }
}
