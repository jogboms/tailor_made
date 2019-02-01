import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkDropDown extends StatefulWidget {
  const MkDropDown({
    Key key,
    this.hint,
    this.value,
    @required this.items,
    @required this.onChanged,
    this.isExpanded,
    this.hasError = false,
  }) : super(key: key);

  final String hint;
  final String value;
  final List<String> items;
  final FormFieldSetter<String> onChanged;
  final bool isExpanded;
  final bool hasError;

  @override
  MkDropDownState createState() => MkDropDownState();
}

class MkDropDownState extends State<MkDropDown> {
  String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(MkDropDown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context), _style = _theme.subhead1Semi;

    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: MkBorderSide(
            color: (widget.hasError ?? false) ? _theme.errorStyle.color : null,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: widget.items.contains(_value) ? _value : null,
          isExpanded: widget.isExpanded ?? true,
          hint: Text(
            _value ?? widget.hint ?? "Click here to drop down",
            style: _value == null ? _theme.textfieldLabel : _theme.textfield,
          ),
          elevation: 1,
          items: widget.items.map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: _style),
              );
            },
          ).toList(),
          onChanged: (String value) {
            setState(() {
              _value = value;
              widget.onChanged(value);
            });
          },
        ),
      ),
    );
  }
}
