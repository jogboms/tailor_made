import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'image_form_value.dart';

class GalleryGridItem extends StatelessWidget {
  GalleryGridItem({
    super.key,
    required this.tag,
    required this.src,
    required this.contactID,
    required this.jobID,
    this.onTapDelete,
    double? size,
  }) : size = Size.square(size ?? kGridWidth);

  static GalleryGridItem formValue({
    Key? key,
    required ImageFormValue value,
    double? size,
    ValueChanged<ImageFormValue>? onTapDelete,
  }) {
    switch (value) {
      case ImageCreateFormValue():
        final CreateImageData data = value.data;
        return GalleryGridItem(
          key: key,
          tag: data.path,
          src: data.src,
          contactID: data.contactID,
          jobID: data.jobID,
          onTapDelete: () => onTapDelete?.call(value),
        );
      case ImageModifyFormValue():
        final ImageEntity image = value.data;
        return GalleryGridItem(
          key: key,
          tag: image.id,
          src: image.src,
          contactID: image.contactID,
          jobID: image.jobID,
          onTapDelete: () => onTapDelete?.call(value),
        );
    }
  }

  static const double kGridWidth = 70.0;

  final String tag;
  final String src;
  final String contactID;
  final String jobID;
  final Size size;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Container(
        width: size.width,
        margin: const EdgeInsets.only(right: 8.0),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          child: Ink.image(
            image: NetworkImage(src),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () => context.router.toGalleryImage(
                src: src,
                contactID: contactID,
                jobID: jobID,
              ),
              child: onTapDelete != null
                  ? Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => onTapDelete?.call(),
                        child: const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Icon(Icons.cancel, color: Colors.red),
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
