import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_child_dialog.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/_views/slide_down.dart';
import 'package:tailor_made/widgets/screens/measures/measures_create.dart';
import 'package:tailor_made/widgets/screens/measures/measures_manage.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measures_slide_block_item.dart';

enum ActionChoice {
  edit,
  delete,
}

class MeasureSlideBlock extends StatefulWidget {
  const MeasureSlideBlock({
    Key key,
    @required this.measures,
    @required this.parent,
    @required this.title,
  }) : super(key: key);

  final List<MeasureModel> measures;
  final MeasuresManagePageState parent;
  final String title;

  @override
  _MeasureSlideBlockState createState() => _MeasureSlideBlockState();
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

    return SlideDownItem(
      title: widget.title,
      body: Container(
        // color: kBorderSideColor.withOpacity(.25),
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
    return mkShowChildDialog<ActionChoice>(
      context: context,
      child: SimpleDialog(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, ActionChoice.edit),
            child: Padding(
              child: Text("Edit"),
              padding: EdgeInsets.all(8.0),
            ),
          ),
          SimpleDialogOption(
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
    MkNavigate(
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
    final choice = await mkChoiceDialog(
      context: context,
      title: "",
      message: "Are you sure?",
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
