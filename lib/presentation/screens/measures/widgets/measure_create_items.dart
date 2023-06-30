import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';

import '../widgets/slide_down_item.dart';

class MeasureCreateItems extends StatelessWidget {
  const MeasureCreateItems({
    super.key,
    required this.grouped,
    required this.measurements,
    required this.onSaved,
    this.onChanged,
  });

  final Map<MeasureGroup, List<MeasureEntity>> grouped;
  final Map<String, double> measurements;
  final FormFieldSetter<Map<String, double>> onSaved;
  final ValueChanged<Map<String, double>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<Map<String, double>>(
      onSaved: onSaved,
      initialValue: <String, double>{...measurements},
      builder: (FormFieldState<Map<String, double>> field) {
        final Map<String, double> currentValue = field.value ?? <String, double>{};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 0; i < grouped.length; i++)
              SlideDownItem(
                title: grouped.keys.elementAt(i).displayName,
                body: _JobMeasureBlock(
                  key: ValueKey<MeasureGroup>(grouped.keys.elementAt(i)),
                  measures: grouped.values.elementAt(i),
                  measurements: currentValue,
                  onChanged: ((String, double?) value) {
                    currentValue[value.$1] = value.$2 ?? 0.0;
                    field.didChange(currentValue);
                    onChanged?.call(currentValue);
                  },
                ),
              ),
            if (field.errorText case final String errorText)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  errorText,
                  style: context.theme.inputDecorationTheme.errorStyle,
                  textAlign: TextAlign.start,
                ),
              ),
          ],
        );
      },
    );
  }
}

// TODO(Jogboms): should rework this
class _JobMeasureBlock extends StatelessWidget {
  const _JobMeasureBlock({
    super.key,
    required this.measures,
    required this.measurements,
    required this.onChanged,
  });

  final List<MeasureEntity> measures;
  final Map<String, double> measurements;
  final ValueChanged<(String, double?)> onChanged;

  @override
  Widget build(BuildContext context) {
    final int length = measures.length;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: measures.map((MeasureEntity measure) {
          final int index = measures.indexOf(measure);

          final num? value1 = measurements.containsKey(measure.id) ? measurements[measure.id] : 0;
          final String value = value1 != null && value1 > 0 ? value1.toString() : '';

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool removeBorder = (length % 2 != 0 && (index == length - 1)) ||
                  (length.isEven && (index == length - 1 || index == length - 2));
              return Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: AppBorderSide(
                      style: removeBorder ? BorderStyle.none : BorderStyle.solid,
                    ),
                    right: AppBorderSide(
                      style: index.isEven ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                ),
                width: constraints.maxWidth / 2,
                child: _MeasureField(
                  key: Key(measure.name),
                  label: measure.name,
                  value: value,
                  onChanged: (double? value) => onChanged((measure.id, value)),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _MeasureField extends StatefulWidget {
  const _MeasureField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<double?> onChanged;

  @override
  State<_MeasureField> createState() => _MeasureFieldState();
}

class _MeasureFieldState extends State<_MeasureField> {
  late final TextEditingController _controller = TextEditingController(text: widget.value);

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: Theme.of(context).headline,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: widget.label,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorBorder: InputBorder.none,
      ),
      onChanged: (String value) => widget.onChanged(double.tryParse(value)),
    );
  }
}
