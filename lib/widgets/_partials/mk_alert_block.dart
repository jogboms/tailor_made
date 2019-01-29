import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkAlertBlock extends StatelessWidget {
  const MkAlertBlock({
    Key key,
    @required this.message,
    @required this.backgroundColor,
    this.color = Colors.white,
    this.icon = Icons.info,
    this.margin = const EdgeInsets.all(12.0),
  }) : super(key: key);

  final String message;
  final Color backgroundColor;
  final Color color;
  final IconData icon;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: backgroundColor,
        elevation: 1.0,
        borderRadius: BorderRadius.circular(6.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Icon(icon, color: color),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  message,
                  style: MkTheme.of(context).bodySemi.copyWith(
                        color: color,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
