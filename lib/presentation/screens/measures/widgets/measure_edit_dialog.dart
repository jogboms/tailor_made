import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/widgets.dart';

import '../../../theme.dart';
import '../../../utils.dart';

class MeasureEditDialog extends StatefulWidget {
  const MeasureEditDialog({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  State<MeasureEditDialog> createState() => _MeasureEditDialogState();
}

class _MeasureEditDialogState extends State<MeasureEditDialog> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final L10n l10n = context.l10n;

    return Align(
      alignment: const FractionalOffset(0.0, 0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          borderRadius: BorderRadius.circular(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16.0),
              Center(child: Text(widget.title, style: theme.textTheme.bodySmallLight)),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: _controller,
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AppClearButton(
                    onPressed: Navigator.of(context).pop,
                    color: colorScheme.outline,
                    child: Text(l10n.cancelCaption),
                  ),
                  const SizedBox(width: 16.0),
                  AppClearButton(onPressed: _handleSubmit, child: Text(l10n.doneCaption)),
                  const SizedBox(width: 16.0),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final String newValue = _controller.text.trim();
    if (newValue.length > 1) {
      Navigator.of(context).pop(newValue);
    }
  }
}
