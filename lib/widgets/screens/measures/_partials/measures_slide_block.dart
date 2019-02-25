import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures.dart';
import 'package:tailor_made/utils/mk_child_dialog.dart';
import 'package:tailor_made/utils/mk_choice_dialog.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_snackbar.dart';
import 'package:tailor_made/widgets/_views/slide_down.dart';
import 'package:tailor_made/widgets/screens/measures/_partials/measures_slide_block_item.dart';
import 'package:tailor_made/widgets/screens/measures/measures_create.dart';

enum ActionChoice {
  edit,
  delete,
}

class MeasureSlideBlock extends StatefulWidget {
  const MeasureSlideBlock({
    Key key,
    @required this.measures,
    @required this.title,
  }) : super(key: key);

  final List<MeasureModel> measures;
  final String title;

  @override
  _MeasureSlideBlockState createState() => _MeasureSlideBlockState();
}

class _MeasureSlideBlockState extends State<MeasureSlideBlock> {
  @override
  Widget build(BuildContext context) {
    final children = widget.measures
        .map<Widget>(
          (measure) => MeasuresSlideBlockItem(measure: measure),
        )
        .toList();

    return SlideDownItem(
      title: widget.title,
      body: Column(
        children: children,
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
            onPressed: () {
              Navigator.pop(context, ActionChoice.edit);
            },
            child: Padding(
              child: const Text("Edit"),
              padding: const EdgeInsets.all(8.0),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, ActionChoice.delete);
            },
            child: Padding(
              child: const Text("Delete"),
              padding: const EdgeInsets.all(8.0),
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

    MkSnackBar.of(context).loading();
    try {
      await Measures.delete(widget.measures);

      MkSnackBar.of(context).hide();
    } catch (e) {
      MkSnackBar.of(context).show(e.toString());
    }
  }
}
