import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/_partials/mk_check_box.dart';

class MkRadio<T> extends StatefulWidget {
  const MkRadio({
    Key key,
    this.title,
    @required this.groupValue,
    @required this.value,
    @required this.onPressed,
  }) : super(key: key);

  final T groupValue;
  final T value;
  final void Function(T) onPressed;
  final String title;

  @override
  _MkRadioState<T> createState() => _MkRadioState<T>();
}

class _MkRadioState<T> extends State<MkRadio<T>> {
  @override
  Widget build(BuildContext context) {
    return MkCheckBox(
      title: widget.title,
      isRadio: true,
      isChecked: widget.value == widget.groupValue,
      onPressed: (bool state) => widget.onPressed(widget.value),
    );
  }
}
