import 'package:flutter/widgets.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_drop_down.dart';

class MkDropDownField extends StatelessWidget {
  const MkDropDownField({
    Key key,
    this.hint,
    @required this.items,
    this.onSaved,
    this.validator,
    this.initialValue,
    this.autovalidate = false,
    this.onChanged,
    this.isExpanded,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final String initialValue;
  final bool autovalidate;
  final String hint;
  final List<String> items;
  final FormFieldSetter<String> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue != null && initialValue.isNotEmpty ? initialValue : null,
      autovalidate: autovalidate,
      builder: (FormFieldState<String> field) {
        final child = MkDropDown(
          hint: hint,
          value: field.value,
          items: items,
          hasError: field.hasError,
          onChanged: (String value) {
            field.didChange(value);
            if (onChanged != null) {
              onChanged(value);
            }
          },
          isExpanded: isExpanded,
        );
        return field.hasError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  child,
                  const SizedBox(height: 4.0),
                  Text(
                    field.errorText,
                    style: MkTheme.of(context).errorStyle,
                  ),
                ],
              )
            : child;
      },
      validator: validator,
      onSaved: onSaved,
    );
  }
}
