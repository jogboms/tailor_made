import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../providers/measurement_provider.dart';
import '../widgets/slide_down_item.dart';
import 'measure_edit_dialog.dart';
import 'measures_slide_block_item.dart';

enum _ActionChoice { edit, delete }

class MeasureSlideBlock extends StatefulWidget {
  const MeasureSlideBlock({
    super.key,
    required this.measures,
    required this.groupName,
    required this.userId,
  });

  final List<MeasureEntity> measures;
  final MeasureGroup groupName;
  final String userId;

  @override
  State<MeasureSlideBlock> createState() => _MeasureSlideBlockState();
}

class _MeasureSlideBlockState extends State<MeasureSlideBlock> {
  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, _) => SlideDownItem(
        title: widget.groupName.displayName,
        body: Column(
          children: <Widget>[
            for (MeasureEntity measure in widget.measures)
              MeasuresSlideBlockItem(
                measure: measure,
                onTap: () => _onTapEditItem(l10n, ref.read(measurementProvider), measure),
              ),
          ],
        ),
        onLongPress: () async {
          final _ActionChoice? choice = await showChildDialog<_ActionChoice>(
            context: context,
            child: SimpleDialog(
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, _ActionChoice.edit),
                  child: Text(l10n.editCaption),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, _ActionChoice.delete),
                  child: Text(l10n.deleteCaption),
                ),
              ],
            ),
          );

          switch (choice) {
            case _ActionChoice.edit:
              _onTapEditBlock();
            case _ActionChoice.delete:
              _onTapDeleteBlock(l10n, ref.read(measurementProvider));
            case null:
              return;
          }
        },
      ),
    );
  }

  void _onTapEditBlock() {
    context.router.toCreateMeasures(
      groupName: widget.groupName,
      unitValue: widget.measures.first.unit,
      measures: widget.measures,
    );
  }

  void _onTapDeleteBlock(L10n l10n, MeasurementProvider measurementProvider) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final bool? choice = await showChoiceDialog(
      context: context,
      title: l10n.deleteMeasurementPageTitle,
      message: l10n.confirmationMessage,
    );
    if (choice == null || choice == false) {
      return;
    }

    snackBar.loading();
    try {
      await measurementProvider.deleteGroup(measures: widget.measures);
      snackBar.hide();
    } catch (e) {
      snackBar.error(e.toString());
    }
  }

  void _onTapEditItem(L10n l10n, MeasurementProvider measurementProvider, MeasureEntity measure) async {
    final AppSnackBar snackBar = AppSnackBar.of(context);
    final String? itemName = await showChildDialog<String>(
      context: context,
      child: MeasureEditDialog(
        title: l10n.measurementItemNamePageTitle,
        value: measure.name,
      ),
    );
    if (itemName == null) {
      return;
    }

    snackBar.loading();
    try {
      await measurementProvider.updateName(reference: measure.reference, name: itemName);
      snackBar.hide();
    } catch (error, stackTrace) {
      AppLog.e(error, stackTrace);
      snackBar.error(error.toString());
    }
  }
}
