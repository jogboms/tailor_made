import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureSlideBlock extends StatefulWidget {
  final List<MeasureModel> measures;
  final AccountMeasuresPageState parent;
  final String title;

  const MeasureSlideBlock({
    Key key,
    @required this.measures,
    @required this.parent,
    @required this.title,
  }) : super(key: key);

  @override
  _MeasureSlideBlockState createState() => new _MeasureSlideBlockState();
}

class _MeasureSlideBlockState extends State<MeasureSlideBlock> {
  @override
  Widget build(BuildContext context) {
    final children = widget.measures.map<Widget>((measure) {
      return ListTile(
        dense: true,
        title: Text(measure.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: kHintColor,
              ),
              iconSize: 20.0,
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: kHintColor,
              ),
              iconSize: 20.0,
              onPressed: () => onTapDeleteItem(measure),
            ),
          ],
        ),
      );
    }).toList();

    return new SlideDownItem(
      title: widget.title,
      body: Container(
        color: kBorderSideColor.withOpacity(.5),
        child: Column(
          children: children,
        ),
      ),
      onLongPress: () async {
        final choice = await showChildDialog<ActionChoice>(
          context: context,
          child: new SimpleDialog(
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, ActionChoice.edit),
                child: Padding(
                  child: Text("Edit"),
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              new SimpleDialogOption(
                onPressed: () => Navigator.pop(context, ActionChoice.delete),
                child: Padding(
                  child: Text("Delete"),
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            ],
          ),
        );

        if (choice == null) {
          return;
        }

        if (choice == ActionChoice.edit) {
          onTapEditBlock();
        } else if (choice == ActionChoice.delete) {
          onTapDeleteBlock();
        }
      },
    );
  }

  void onTapEditBlock() async {
    // final choice = await confirmDialog(
    //   context: context,
    //   content: Text("Are you sure?"),
    // );
    // if (choice == null || choice == false) {
    //   return;
    // }

    // final WriteBatch batch = CloudDb.instance.batch();

    // widget.measures.forEach((measure) {
    //   batch.updateData(
    //     CloudDb.measurements.document(measure.id),
    //     measure.toMap(),
    //   );
    // });

    // showLoadingSnackBar();
    // try {
    //   await batch.commit();

    //   closeLoadingSnackBar();
    // } catch (e) {
    //   closeLoadingSnackBar();
    //   showInSnackBar(e.toString());
    // }
  }

  void onTapDeleteBlock() async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    final WriteBatch batch = CloudDb.instance.batch();

    widget.measures.forEach((measure) {
      batch.delete(
        CloudDb.measurements.document(measure.id),
      );
    });

    widget.parent.showLoadingSnackBar();
    try {
      await batch.commit();

      widget.parent.closeLoadingSnackBar();
    } catch (e) {
      widget.parent.closeLoadingSnackBar();
      widget.parent.showInSnackBar(e.toString());
    }
  }

  void onTapEditItem(MeasureModel measure) async {
    final choice = await confirmDialog(
      context: context,
      content: Text("Are you sure?"),
    );
    if (choice == null || choice == false) {
      return;
    }

    widget.parent.showLoadingSnackBar();

    try {
      await measure.reference.updateData(<String, String>{
        "name": "",
        "unit": "",
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
