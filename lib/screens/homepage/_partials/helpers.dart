import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class TMListTile extends StatelessWidget {
  const TMListTile({super.key, this.icon, this.color, this.title, this.onPressed});

  final IconData? icon;
  final Color? color;
  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _CircleIcon(icon: icon, color: color, small: true),
        _TextTile(title: title, small: true),
      ],
    );
  }
}

class TMGridTile extends StatelessWidget {
  const TMGridTile({super.key, this.icon, this.color, this.title, this.subTitle, this.onPressed});

  final IconData? icon;
  final Color? color;
  final String? title;
  final String? subTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.only(left: 20.0),
        surfaceTintColor: color!.withOpacity(.25),
      ),
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          _CircleIcon(icon: icon, color: color),
          _TextTile(title: title, subTitle: subTitle),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({this.icon, this.color = MkColors.accent, this.small = false});

  final IconData? icon;
  final Color? color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(right: small == true ? 8.0 : 10.0),
        child: CircleAvatar(
          backgroundColor: color,
          radius: small == true ? 14.0 : 20.0,
          child: Icon(icon, size: small == true ? 14.0 : 20.0, color: Colors.white),
        ),
      ),
    );
  }
}

class _TextTile extends StatelessWidget {
  const _TextTile({this.title, this.subTitle, this.small = false});

  final String? title;
  final String? subTitle;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title!, style: TextStyle(fontSize: small == true ? 15.0 : 16.0)),
        if (subTitle != null) Text(subTitle!, style: ThemeProvider.of(context)!.small),
      ],
    );
  }
}
