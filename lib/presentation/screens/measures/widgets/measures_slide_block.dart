import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import '../widgets/slide_down_item.dart';
import 'measures_slide_block_item.dart';

enum _ActionChoice { edit, delete }

class MeasureSlideBlock extends StatefulWidget {
  const MeasureSlideBlock({
    super.key,
    required this.measures,
    required this.title,
    required this.userId,
  });

  final List<MeasureModel> measures;
  final String title;
  final String userId;

  @override
  State<MeasureSlideBlock> createState() => _MeasureSlideBlockState();
}

class _MeasureSlideBlockState extends State<MeasureSlideBlock> {
  @override
  Widget build(BuildContext context) {
    return SlideDownItem(
      title: widget.title,
      body: Column(
        children: <Widget>[
          for (MeasureModel measure in widget.measures) MeasuresSlideBlockItem(measure: measure),
        ],
      ),
      onLongPress: () async {
        final _ActionChoice? choice = await _showOptionsDialog();

        if (choice == null) {
          return;
        }

        if (choice == _ActionChoice.edit) {
          _onTapEditBlock();
        } else if (choice == _ActionChoice.delete) {
          _onTapDeleteBlock();
        }
      },
    );
  }

  Future<_ActionChoice?> _showOptionsDialog() {
    return showChildDialog<_ActionChoice>(
      context: context,
      child: SimpleDialog(
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, _ActionChoice.edit),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Edit'),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, _ActionChoice.delete),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Delete'),
            ),
          ),
        ],
      ),
    );
  }

  void _onTapEditBlock() {
    Dependencies.di()
        .get<MeasuresCoordinator>()
        .toCreateMeasures(widget.title, widget.measures.first.unit, widget.measures);
  }

  void _onTapDeleteBlock() async {
    final SnackBarProvider snackBar = SnackBarProvider.of(context);
    final bool? choice = await showChoiceDialog(context: context, title: '', message: 'Are you sure?');
    if (choice == null || choice == false) {
      return;
    }

    snackBar.loading();
    try {
      // TODO(Jogboms): move this out of here
      await Dependencies.di().get<Measures>().delete(widget.measures, widget.userId);

      snackBar.hide();
    } catch (e) {
      snackBar.show(e.toString());
    }
  }
}
