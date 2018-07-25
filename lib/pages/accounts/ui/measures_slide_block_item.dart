import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/measures.dart';
import 'package:tailor_made/pages/accounts/ui/measure_edit_dialog.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasuresSlideBlockItem extends StatefulWidget {
  final MeasureModel measure;
  final AccountMeasuresPageState parent;

  const MeasuresSlideBlockItem({
    Key key,
    @required this.measure,
    @required this.parent,
  }) : super(key: key);

  @override
  _MeasuresSlideBlockItemState createState() =>
      new _MeasuresSlideBlockItemState();
}

class _MeasuresSlideBlockItemState extends State<MeasuresSlideBlockItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(widget.measure.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: kHintColor,
            ),
            iconSize: 20.0,
            onPressed: () => onTapEditItem(widget.measure),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: kHintColor,
            ),
            iconSize: 20.0,
            onPressed: () => onTapDeleteItem(widget.measure),
          ),
        ],
      ),
    );
  }

  void onTapEditItem(MeasureModel measure) async {
    final _controller = TextEditingController(text: measure.name);
    final itemName = await showEditDialog(
      context: context,
      title: "ITEM NAME",
      children: <Widget>[
        TextField(
          textCapitalization: TextCapitalization.words,
          controller: _controller,
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
      ],
    );

    if (itemName == null) {
      return;
    }

    widget.parent.showLoadingSnackBar();

    try {
      await measure.reference.updateData(<String, String>{
        "name": itemName,
        // "unit": "",
      });
      widget.parent.closeLoadingSnackBar();
    } catch (e) {
      widget.parent.closeLoadingSnackBar();
      widget.parent.showInSnackBar(e.toString());
    }
  }

  void onTapDeleteItem(MeasureModel measure) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    widget.parent.showLoadingSnackBar();

    try {
      await measure.reference.delete();
      widget.parent.closeLoadingSnackBar();
    } catch (e) {
      widget.parent.closeLoadingSnackBar();
      widget.parent.showInSnackBar(e.toString());
    }
  }
}
