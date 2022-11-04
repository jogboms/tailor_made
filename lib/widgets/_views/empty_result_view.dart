import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({super.key, this.message = 'No results'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;
    return Opacity(
      opacity: .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.equalizer, color: kPrimaryColor, size: 36.0),
          const SizedBox(height: 8.0),
          Text(message, style: theme.small.copyWith(fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
