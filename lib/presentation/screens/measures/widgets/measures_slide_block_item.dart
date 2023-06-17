import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';

import '../../../widgets.dart';
import 'measure_edit_dialog.dart';

class MeasuresSlideBlockItem extends StatefulWidget {
  const MeasuresSlideBlockItem({super.key, required this.measure});

  final MeasureModel measure;

  @override
  State<MeasuresSlideBlockItem> createState() => _MeasuresSlideBlockItemState();
}

class _MeasuresSlideBlockItemState extends State<MeasuresSlideBlockItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(widget.measure.name),
      subtitle: Text(widget.measure.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkResponse(
            child: Icon(Icons.settings, color: kPrimaryColor.withOpacity(.75)),
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

  void _onTapEditItem(MeasureModel measure) async {
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
      await measure.reference?.updateData(<String, String>{'name': itemName});
      snackBar.hide();
    } catch (e) {
      snackBar.error(e.toString());
    }
  }
}
