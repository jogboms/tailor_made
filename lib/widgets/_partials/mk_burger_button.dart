import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_icons.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';

class MkBurgerButton extends MkClearButton {
  MkBurgerButton({
    Key key,
    Color color,
    VoidCallback onPressed,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: ImageIcon(
            MkIcons.menu,
            color: color,
            size: 22.0,
          ),
        );
}
