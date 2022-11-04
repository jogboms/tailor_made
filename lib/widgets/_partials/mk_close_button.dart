import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MkCloseButton extends StatelessWidget {
  const MkCloseButton({super.key, this.color, this.onPop});

  final Color? color;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return MkClearButton(
      onPressed: onPop ?? () => Navigator.maybePop(context),
      child: Icon(Icons.close, color: color ?? ThemeProvider.of(context)!.appBarTitle.color),
    );
  }
}
