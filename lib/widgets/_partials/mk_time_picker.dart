import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_fake_text_field.dart';

class MkTimePicker extends StatefulWidget {
  const MkTimePicker({
    Key key,
    this.hint,
    this.initialValue,
    this.autovalidate = false,
    @required this.onChanged,
    this.isEnabled = true,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  final bool isEnabled;
  final String hint;
  final TimeOfDay initialValue;
  final ValueSetter<TimeOfDay> onChanged;
  final ValueSetter<TimeOfDay> onSaved;
  final FormFieldValidator<TimeOfDay> validator;
  final bool autovalidate;

  @override
  MkTimePickerState createState() => MkTimePickerState();
}

class MkTimePickerState extends State<MkTimePicker> {
  TimeOfDay _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context);

    return MkFakeTextField<TimeOfDay>(
      initialValue: _value,
      validator: widget.validator,
      child: _value == null
          ? Text(
              widget.hint ?? "Select a time",
              style: _theme.bodyHint,
            )
          : Text(
              _value.format(context),
              style: widget.isEnabled ? _theme.textfield : _theme.textfield.copyWith(color: kHintColor),
              textAlign: TextAlign.start,
            ),
      onTap: widget.isEnabled
          ? (FormFieldState<TimeOfDay> field) async {
              final TimeOfDay value = await showTimePicker(
                context: context,
                initialTime: _value,
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
            }
          : null,
      icon: Icons.av_timer,
      onSaved: widget.onSaved,
    );
  }
}
