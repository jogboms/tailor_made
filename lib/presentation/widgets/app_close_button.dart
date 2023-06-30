import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

import 'app_clear_button.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({super.key, this.color, this.onPop});

  final Color? color;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return AppClearButton(
      onPressed: onPop ?? () => Navigator.maybePop(context),
      child: Icon(Icons.close, color: color ?? ThemeProvider.of(context).appBarTitle.color),
    );
  }
}
