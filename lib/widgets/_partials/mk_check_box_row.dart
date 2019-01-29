import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/utils/mk_validators.dart';
import 'package:tailor_made/widgets/_partials/mk_check_box.dart';

class MkCheckBoxRowBuilder extends StatelessWidget {
  const MkCheckBoxRowBuilder({
    Key key,
    @required this.count,
    @required this.itemBuilder,
    this.divider,
  }) : super(key: key);

  final IndexedWidgetBuilder itemBuilder;
  final int count;
  final Widget divider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count * 2 - 1, (int i) {
        final index = i ~/ 2;

        if (i == 0 || i.isEven) {
          return itemBuilder(context, index);
        }
        return divider ?? const SizedBox(width: 8.0);
      }),
    );
  }
}

class MkCheckBoxField extends StatelessWidget {
  const MkCheckBoxField({
    Key key,
    @required this.title,
    @required this.fieldValue,
    @required this.field,
    this.color,
    this.selectedColor = MkColors.orange,
    this.border,
    this.padding,
  }) : super(key: key);

  final String title;
  final ShapeBorder border;
  final Color color;
  final Color selectedColor;
  final String fieldValue;
  final FormFieldState<List<String>> field;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: border,
      child: MkCheckBox(
        title: title,
        selectedColor: selectedColor,
        color: field.hasError ? MkTheme.of(context).errorStyle.color : color,
        isChecked: field.value?.contains(fieldValue) ?? false,
        padding: padding,
        onPressed: (bool value) {
          final _values = List<String>.from(field.value);
          if (value) {
            _values.add(fieldValue);
          } else {
            _values.remove(fieldValue);
          }
          field.didChange(_values);
        },
      ),
    );
  }
}

class MkCheckBoxRow extends StatelessWidget {
  const MkCheckBoxRow({
    Key key,
    this.autovalidate = false,
    this.initialValue,
    @required this.builder,
    @required this.onSaved,
  }) : super(key: key);

  final Widget Function(FormFieldState<List<String>>) builder;
  final void Function(List<String>) onSaved;
  final List<String> initialValue;
  final bool autovalidate;

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      initialValue: initialValue != null ? List.from(initialValue) : [],
      builder: (FormFieldState<List<String>> field) {
        final child = builder(field);

        return field.hasError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                  const SizedBox(height: 6.0),
                  Text(
                    field.errorText,
                    style: MkTheme.of(context).errorStyle,
                  ),
                ],
              )
            : child;
      },
      autovalidate: autovalidate,
      onSaved: onSaved,
      validator: MkValidate.tryList("At least one option is required."),
    );
  }
}
