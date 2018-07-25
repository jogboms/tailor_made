import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/accounts/measures.dart';
import 'package:tailor_made/pages/accounts/ui/measures_create.dart';
import 'package:tailor_made/pages/accounts/ui/measures_slide_block_item.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_confirm_dialog.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum ActionChoice {
  edit,
  delete,
}

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
    final children = widget.measures
        .map<Widget>((measure) => MeasuresSlideBlockItem(
              measure: measure,
              parent: widget.parent,
            ))
        .toList();

    return new SlideDownItem(
      title: widget.title,
      body: Container(
        color: kBorderSideColor.withOpacity(.25),
        child: Column(
          children: children,
        ),
      ),
      onLongPress: () async {
        final choice = await _showOptionsDialog();

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

  Future<ActionChoice> _showOptionsDialog() {
    return showChildDialog<ActionChoice>(
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
  }

  void onTapEditBlock() {
    TMNavigate(
      context,
      MeasuresCreate(
        groupName: widget.title,
        unitValue: widget.measures.first.unit,
        measures: widget.measures,
      ),
      fullscreenDialog: true,
    );
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
}
