import 'package:flutter/material.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'measure_edit_dialog.dart';

class MeasuresSlideBlockItem extends StatefulWidget {
  const MeasuresSlideBlockItem({super.key, required this.measure});

  final MeasureEntity measure;

  @override
  State<MeasuresSlideBlockItem> createState() => _MeasuresSlideBlockItemState();
}

class _MeasuresSlideBlockItemState extends State<MeasuresSlideBlockItem> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      dense: true,
      title: Text(widget.measure.name),
      subtitle: Text(widget.measure.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkResponse(
            child: Icon(Icons.settings, color: colorScheme.primary.withOpacity(.75)),
            onTap: () => _onTapEditItem(widget.measure),
          ),
        ],
      ),
    );
  }

  void _onSave(String value) {
    final String newValue = value.trim();
    if (newValue.length > 1) {
      Navigator.pop(context, newValue);
    }
  }

  void _onTapEditItem(MeasureEntity measure) async {
    final Registry registry = context.registry;
    final TextEditingController controller = TextEditingController(text: measure.name);
    final AppSnackBar snackBar = AppSnackBar.of(context);

    final String? itemName = await showEditDialog(
      context: context,
      title: 'ITEM NAME',
      children: <Widget>[
        TextField(
          textCapitalization: TextCapitalization.words,
          controller: controller,
          onSubmitted: _onSave,
        )
      ],
      onDone: () => _onSave(controller.text),
      onCancel: () => Navigator.pop(context),
    );

    if (itemName == null) {
      return;
    }

    snackBar.loading();
    try {
      await registry.get<Measures>().updateOne(measure.reference, name: itemName);
      snackBar.hide();
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }
}
