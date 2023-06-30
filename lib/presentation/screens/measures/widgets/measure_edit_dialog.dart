import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../../theme.dart';

Future<String?> showEditDialog({
  required BuildContext context,
  required List<Widget> children,
  required String title,
  required VoidCallback onDone,
  required VoidCallback onCancel,
}) {
  return showChildDialog<String>(
    context: context,
    child: MeasureEditDialog(title: title, onDone: onDone, onCancel: onCancel, children: children),
  );
}

class MeasureEditDialog extends StatelessWidget {
  const MeasureEditDialog({
    super.key,
    required this.title,
    required this.children,
    required this.onDone,
    required this.onCancel,
  });

  final String title;
  final List<Widget> children;
  final VoidCallback onDone;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const FractionalOffset(0.0, 0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          borderRadius: BorderRadius.circular(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Center(child: Text(title, style: Theme.of(context).smallLight)),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(children: children),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AppClearButton(onPressed: onCancel, color: Colors.grey.shade300, child: const Text('CANCEL')),
                  const SizedBox(width: 16.0),
                  AppClearButton(onPressed: onDone, child: const Text('DONE')),
                  const SizedBox(width: 16.0),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
