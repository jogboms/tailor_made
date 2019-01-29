import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_keyboard_provider.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkFakeTextField<T> extends StatefulWidget {
  const MkFakeTextField({
    Key key,
    @required this.onTap,
    this.initialValue,
    this.hint,
    this.child,
    @required this.icon,
    this.autovalidate = false,
    this.onSaved,
    this.padding,
    this.validator,
  }) : super(key: key);

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final void Function(FormFieldState<T>) onTap;
  final T initialValue;
  final String hint;
  final Widget child;
  final IconData icon;
  final EdgeInsets padding;
  final bool autovalidate;

  @override
  MkFakeTextFieldState<T> createState() => MkFakeTextFieldState<T>();
}

class MkFakeTextFieldState<T> extends State<MkFakeTextField<T>>
    with MkKeyboardProvider {
  bool get isEnabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context);
    return FormField<T>(
      initialValue:
          // widget.initialValue != null && widget.initialValue.isNotEmpty
          widget.initialValue != null ? widget.initialValue : null,
      autovalidate: widget.autovalidate,
      builder: (FormFieldState<T> field) {
        return InkWell(
          onTap: isEnabled
              ? () {
                  closeKeyboard();
                  widget.onTap(field);
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: MkBorderSide(
                  color: (field.hasError ?? false)
                      ? _theme.errorStyle.color
                      : null,
                ),
              ),
              errorText: field.errorText,
              contentPadding: widget.padding,
              suffixIcon: Icon(widget.icon, color: kHintColor),
            ),
            child: widget.child ??
                Text(
                  () {
                    if (field.value != null) {
                      if (field.value is List) {
                        return (field.value as List).isNotEmpty
                            ? "Successfully Added!"
                            : widget.hint;
                      }
                      if (field.value is String) {
                        return (field.value as String).isNotEmpty
                            ? field.value.toString()
                            : widget.hint;
                      }
                      return field.value.toString();
                    }
                    return widget.hint;
                  }(),
                  style: () {
                    if (!isEnabled) {
                      return _theme.title;
                    }
                    if ((field.value != null &&
                            field.value is! List &&
                            field.value is! String) ||
                        (field.value is List &&
                            (field.value as List).isNotEmpty) ||
                        (field.value is String &&
                            (field.value as String).isNotEmpty)) {
                      return _theme.textfield;
                    }

                    return _theme.body3MediumHint;
                  }(),
                ),
          ),
        );
      },
      validator: widget.validator,
      onSaved: widget.onSaved,
    );
  }
}
