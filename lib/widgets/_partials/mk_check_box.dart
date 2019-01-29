import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_touchable_opacity.dart';

class MkCheckBox extends StatefulWidget {
  const MkCheckBox({
    Key key,
    this.title,
    this.color,
    this.isRadio = false,
    this.selectedColor = MkColors.orange,
    this.isChecked = false,
    this.width = 24.0,
    this.shape = BoxShape.circle,
    this.padding,
    @required this.onPressed,
  }) : super(key: key);

  final double width;
  final Color color;
  final Color selectedColor;
  final bool isRadio;
  final bool isChecked;
  final BoxShape shape;
  final EdgeInsets padding;
  final void Function(bool) onPressed;
  final String title;

  @override
  MkCheckBoxState createState() => MkCheckBoxState(isChecked);
}

class MkCheckBoxState extends State<MkCheckBox> {
  MkCheckBoxState(this.isChecked);

  bool isChecked;

  @override
  void didUpdateWidget(MkCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked ||
        (widget.isRadio && !isChecked)) {
      isChecked = widget.isChecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _borderSide = BorderSide(
      color: (isChecked ? widget.selectedColor : widget.color) ?? Colors.grey,
      width: 2.0,
    );

    Widget child = Material(
      clipBehavior: Clip.hardEdge,
      shape: widget.shape == BoxShape.circle
          ? CircleBorder(side: _borderSide)
          : RoundedRectangleBorder(side: _borderSide),
      child: SizedBox.fromSize(
        size: Size.square(widget.width),
        child: isChecked
            ? Material(
                color: widget.selectedColor ?? widget.color ?? Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                ),
              )
            : SizedBox(),
      ),
    );

    if (widget.title != null) {
      child = Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Row(
          children: <Widget>[
            child,
            SizedBox(width: 8.0),
            Text(widget.title, style: MkTheme.of(context).bodySemi)
          ],
        ),
      );
    }

    return MkTouchableOpacity(
      child: child,
      onPressed: () {
        if (widget.isRadio && isChecked) {
          return;
        }
        setState(() => isChecked = !isChecked);
        widget.onPressed(isChecked);
      },
    );
  }
}
