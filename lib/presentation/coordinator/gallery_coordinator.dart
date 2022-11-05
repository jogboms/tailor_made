import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/gallery/gallery.dart';
import '../screens/gallery/widgets/gallery_view.dart';
import 'coordinator_base.dart';

@immutable
class GalleryCoordinator extends CoordinatorBase {
  const GalleryCoordinator(super.navigatorKey);

  void toImage(ImageModel? image) {
    navigator?.push<void>(RouteTransitions.fadeIn(GalleryView(image: image)));
  }

  void toGallery(String userId, [List<ImageModel>? images]) {
    navigator?.push<void>(
      images == null
          ? RouteTransitions.slideIn(GalleryPage(userId: userId))
          : RouteTransitions.slideIn(GalleryPage(userId: userId, images: images), fullscreenDialog: true),
    );
  }
}
