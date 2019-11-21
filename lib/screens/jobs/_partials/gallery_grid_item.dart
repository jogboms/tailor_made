import 'package:flutter/material.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';

class GalleryGridItem extends StatelessWidget {
  GalleryGridItem({Key key, @required this.image, this.onTapDelete, double size})
      : size = Size.square(size ?? _kGridWidth),
        super(key: key);

  final ImageModel image;
  final Size size;
  final ValueSetter<ImageModel> onTapDelete;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return const Center(widthFactor: 2.5, child: MkLoadingSpinner());
    }

    return Hero(
      tag: image.src,
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(right: 8.0),
        child: Material(
          color: Colors.white,
          elevation: 1.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Ink.image(
            image: NetworkImage(image.src),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () => Dependencies.di().galleryCoordinator.toImage(image),
              child: onTapDelete != null
                  ? Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => onTapDelete(image),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: const Icon(Icons.cancel, color: Colors.red),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}

const _kGridWidth = 70.0;
