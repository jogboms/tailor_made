import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

class MeasureDialog extends StatefulWidget {
  const MeasureDialog({super.key, required this.measure});

  final DefaultMeasureEntity measure;

  @override
  State<MeasureDialog> createState() => _MeasureDialogState();
}

class _MeasureDialogState extends State<MeasureDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  late DefaultMeasureEntity _measure = widget.measure;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final L10n l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 32.0),
                Center(
                  child: CircleAvatar(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    radius: 36.0,
                    child: const Icon(Icons.content_cut, size: 50.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onSaved: (String? value) => _measure = _measure.copyWith(name: value!.trim()),
                  decoration: InputDecoration(labelText: l10n.measurementItemNameLabel),
                  validator: InputValidator.tryAlpha(),
                ),
                const SizedBox(height: 4.0),
                TextFormField(
                  initialValue: widget.measure.unit,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: l10n.measurementGroupUnitPlaceholder),
                  validator: InputValidator.tryAlpha(),
                  onFieldSubmitted: (String value) => _onSaved(),
                  onSaved: (String? value) => _measure = _measure.copyWith(unit: value!.trim()),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AppClearButton(
                      onPressed: () => Navigator.pop(context),
                      color: colorScheme.outline,
                      child: Text(l10n.cancelCaption),
                    ),
                    const SizedBox(width: 16.0),
                    AppClearButton(onPressed: _onSaved, child: Text(l10n.doneCaption)),
                    const SizedBox(width: 16.0),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSaved() {
    final FormState? form = _formKey.currentState;
    if (form == null) {
      return;
    }
    if (!form.validate()) {
      _autovalidate = true;
    } else {
      form.save();
      Navigator.pop<DefaultMeasureEntity>(context, _measure);
    }
  }
}
