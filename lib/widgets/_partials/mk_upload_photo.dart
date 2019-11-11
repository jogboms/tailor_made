import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_image_choice_dialog.dart';
import 'package:tailor_made/utils/mk_image_utils.dart';
import 'package:tailor_made/widgets/_partials/mk_touchable_opacity.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MkUploadPhoto extends StatelessWidget {
  const MkUploadPhoto({Key key, this.size = const Size.square(86.0), @required this.onPickImage}) : super(key: key);

  final ValueSetter<File> onPickImage;
  final Size size;

  @override
  Widget build(BuildContext context) {
    const _color = MkColors.primary;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: MkColors.primary.withOpacity(.2),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: MkColors.primary),
        ),
        child: MkTouchableOpacity(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.add_circle, color: _color),
              const SizedBox(height: 2.0),
              Text(
                "Add\nPhoto",
                style: ThemeProvider.of(context).button.copyWith(color: _color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          onPressed: () => _handlePressed(context),
        ),
      ),
    );
  }

  Future<void> _handlePressed(BuildContext context) async {
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
    if (onPickImage != null) {
      final _file = await MkImageUtils(context: context, file: file).resize(width: 1500);
      onPickImage(_file);
    }
  }
}
