import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class FormSectionHeader extends StatelessWidget {
  const FormSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = ThemeProvider.of(context)!.smallSemi;
    return Container(
      color: Colors.grey[100]!.withOpacity(.4),
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title.toUpperCase(), style: style),
          Text(trailing ?? '', style: style),
        ],
      ),
    );
  }
}
