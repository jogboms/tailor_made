import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MkCloseButton extends StatelessWidget {
  const MkCloseButton({Key key, this.color, this.onPop}) : super(key: key);

  final Color color;
  final VoidCallback onPop;

  @override
  Widget build(BuildContext context) {
    return MkClearButton(
      child: Icon(Icons.close, color: color ?? ThemeProvider.of(context).appBarTitle.color),
      onPressed: onPop ?? () => Navigator.maybePop(context),
    );
  }
}
