import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';

import 'touchable_opacity.dart';

class UploadPhoto extends StatelessWidget {
  const UploadPhoto({super.key, this.size = const Size.square(86.0), required this.onPickImage});

  final ValueSetter<File> onPickImage;
  final Size size;

  @override
  Widget build(BuildContext context) {
    const Color color = AppColors.primary;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(.2),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: AppColors.primary),
        ),
        child: TouchableOpacity(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Icon(Icons.add_circle, color: color),
              const SizedBox(height: 2.0),
              Text(
                'Add\nPhoto',
                style: ThemeProvider.of(context).button.copyWith(color: color),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          onPressed: () => _handlePressed(context),
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context) async {
    final ImageSource? source = await showImageChoiceDialog(context: context);
    if (source == null) {
      return;
    }
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile == null) {
        return;
      }
      final File file = await ImageUtils(pickedFile.path).resize(width: 1500);
      onPickImage(file);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}
