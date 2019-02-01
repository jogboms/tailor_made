import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_fake_text_field.dart';

class MkDatePicker extends StatefulWidget {
  const MkDatePicker({
    Key key,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.autovalidate = false,
    this.validator,
  }) : super(key: key);

  final String hint;
  final DateTime initialValue;
  final ValueSetter<DateTime> onChanged;
  final ValueSetter<DateTime> onSaved;
  final FormFieldValidator<DateTime> validator;
  final bool autovalidate;

  @override
  MkDatePickerState createState() => MkDatePickerState();
}

class MkDatePickerState extends State<MkDatePicker> {
  DateTime _value;

  String _format(DateTime date) => "${DateFormat.yMMMd().format(date)}";

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context);

    return MkFakeTextField<DateTime>(
      initialValue: _value,
      validator: widget.validator,
      child: _value == null
          ? Text(
              widget.hint ?? "Select a date",
              style: _theme.bodyHint,
            )
          : Text(
              _format(_value),
              style: _theme.textfield,
              textAlign: TextAlign.start,
            ),
      onTap: (FormFieldState<DateTime> field) async {
        final DateTime value = await showDatePicker(
          context: context,
          initialDate: _value,
          firstDate: DateTime(1900, 8),
          lastDate: DateTime(2101),
        );
        if (value != null && value != _value) {
          setState(() {
            _value = value;
            field.didChange(value);
            if (widget.onChanged != null) {
              widget.onChanged(value);
            }
          });
        }
      },
      icon: Icons.calendar_today,
      onSaved: widget.onSaved,
    );
  }
}
