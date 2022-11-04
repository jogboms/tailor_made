import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MkBackButton extends StatelessWidget {
  const MkBackButton({super.key, this.color, this.onPop});

  final Color? color;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return MkClearButton(
      onPressed: onPop ?? () => Navigator.maybePop(context),
      child: Icon(
        Icons.arrow_back_ios,
        color: color ?? ThemeProvider.of(context)!.appBarTitle.color,
        size: 18.0,
      ),
    );
  }
}
