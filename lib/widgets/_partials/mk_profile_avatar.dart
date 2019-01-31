import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_image_utils.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_partials/mk_touchable_opacity.dart';

class MkProfileAvatar extends StatefulWidget {
  const MkProfileAvatar({
    Key key,
    this.radius = 32.0,
    this.imageUrl,
    this.simple = false,
    this.onPickImage,
  }) : super(key: key);

  final double radius;
  final String imageUrl;
  final bool simple;
  final void Function(File file) onPickImage;

  @override
  MkProfileAvatarState createState() => MkProfileAvatarState(imageUrl);
}

class MkProfileAvatarState extends State<MkProfileAvatar> {
  MkProfileAvatarState(this.imageUrl);

  String imageUrl;
  Image image;
  bool isUploading = false;

  @override
  void didUpdateWidget(MkProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (imageUrl != widget.imageUrl) {
      setState(() => imageUrl = widget.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _borderRadius = BorderRadius.circular(45.0);
    return SizedBox.fromSize(
      size: Size.square(widget.radius * 2),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Material(
              color: MkColors.light_grey.withOpacity(.2),
              clipBehavior: Clip.hardEdge,
              borderRadius: _borderRadius,
              child: _buildImage(),
            ),
          ),
          Align(
            alignment: const Alignment(1.15, 1.05),
            child: SizedBox.fromSize(
              size: const Size.square(35.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: MkColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: MkTouchableOpacity(
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () => _handlePhotoButtonPressed(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePhotoButtonPressed(BuildContext context) async {
    final source = await mkImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    File file;
    try {
      file = await ImagePicker.pickImage(source: source);
      print("File path: " + file.path);
    } on PlatformException catch (e) {
      print("Error while picking the file: " + e.toString());
    }
    if (file == null) {
      return;
    }
    if (widget.onPickImage != null) {
      final _file = await MkImageUtils(context: context, file: file).resize();
      widget.onPickImage(_file);
    }
    setState(() {
      image = Image.file(
        file,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
      isUploading = true;
    });
  }

  Widget _buildImage() {
    print([imageUrl]);
    final _color = MkColors.dark.shade400;
    return imageUrl != null || image != null
        ? isUploading == false
            ? CachedNetworkImage(
                placeholder: MkLoadingSpinner(
                  size: widget.radius / 2,
                ),
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              )
            : image
        : widget.simple
            ? const SizedBox()
            : SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.photo_camera,
                      color: _color,
                      size: 32.0,
                    ),
                    Text(
                      "Upload\nPhoto",
                      style: MkTheme.of(context).button.copyWith(color: _color),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
  }
}
