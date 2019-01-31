import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkRatingField extends StatelessWidget {
  const MkRatingField({
    Key key,
    this.onSaved,
    this.initialValue,
    this.iconSize,
    this.autovalidate,
    this.mainAxisAlignment,
    this.errorCrossAxisAlignment,
    this.validator,
  }) : super(key: key);

  final void Function(int) onSaved;
  final int initialValue;
  final bool autovalidate;
  final double iconSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment errorCrossAxisAlignment;
  final FormFieldValidator<int> validator;

  @override
  Widget build(BuildContext context) {
    return FormField<int>(
      autovalidate: autovalidate ?? false,
      initialValue: initialValue,
      validator: validator,
      builder: (FormFieldState<int> field) {
        final child = Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
          children: List.generate(5, (int index) {
            return ConstrainedBox(
              constraints: BoxConstraints.tight(const Size.square(48.0)),
              child: InkWell(
                child: Icon(
                  Icons.star,
                  size: iconSize ?? 32.0,
                  color: index < field.value
                      ? MkColors.accent
                      : MkColors.light_grey.withOpacity(.35),
                ),
                onTap: () => field.didChange(index + 1),
              ),
            );
          }),
        );

        return field.hasError
            ? Column(
                crossAxisAlignment:
                    errorCrossAxisAlignment ?? CrossAxisAlignment.start,
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
      onSaved: onSaved,
    );
  }
}
