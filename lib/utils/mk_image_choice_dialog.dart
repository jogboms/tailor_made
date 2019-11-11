import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_child_dialog.dart';
import 'package:image_picker/image_picker.dart';

Future<ImageSource> mkImageChoiceDialog({
  @required BuildContext context,
}) =>
    mkShowChildDialog(
      context: context,
      child: SimpleDialog(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Padding(
              child: Text("Camera"),
              padding: EdgeInsets.all(8.0),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Padding(
              child: Text("Gallery"),
              padding: EdgeInsets.all(8.0),
            ),
          ),
        ],
      ),
    );
