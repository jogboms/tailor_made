import 'package:flutter/material.dart';

import 'app_clear_button.dart';

class AppCloseButton extends StatelessWidget {
  const AppCloseButton({super.key, this.color, this.onPop});

  final Color? color;
  final VoidCallback? onPop;

  @override
  Widget build(BuildContext context) {
    return AppClearButton(
      onPressed: onPop ?? () => Navigator.maybePop(context),
      child: const Icon(Icons.close),
    );
  }
}
