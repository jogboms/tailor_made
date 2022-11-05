import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'show_child_dialog.dart';

Future<ImageSource?> showImageChoiceDialog({required BuildContext context}) => showChildDialog(
      context: context,
      child: SimpleDialog(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Camera')),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: const Padding(padding: EdgeInsets.all(8.0), child: Text('Gallery')),
          ),
        ],
      ),
    );
