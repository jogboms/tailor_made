import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/measures.dart';
import 'package:tailor_made/pages/accounts/ui/measure_edit_dialog.dart';
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
      subtitle: Text(widget.measure.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkResponse(
            child: Icon(
              Icons.settings,
              color: kPrimaryColor.withOpacity(.75),
            ),
            onTap: () => onTapEditItem(widget.measure),
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
}
