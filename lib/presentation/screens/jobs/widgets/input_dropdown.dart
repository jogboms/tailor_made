import 'package:flutter/material.dart';

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    super.key,
    this.labelText,
    required this.valueText,
    this.onPressed,
  });

  final String? labelText;
  final String valueText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText, isDense: true),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
