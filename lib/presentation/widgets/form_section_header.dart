import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle? textStyle = theme.textTheme.bodySmall?.copyWith(fontWeight: AppFontWeight.semibold);

    return Container(
      color: colorScheme.outlineVariant.withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title.toUpperCase(), style: textStyle),
          Text(trailing ?? '', style: textStyle),
        ],
      ),
    );
  }
}
