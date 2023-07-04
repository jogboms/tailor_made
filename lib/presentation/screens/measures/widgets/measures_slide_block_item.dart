import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';

class MeasuresSlideBlockItem extends StatefulWidget {
  const MeasuresSlideBlockItem({super.key, required this.measure, required this.onTap});

  final MeasureEntity measure;
  final VoidCallback onTap;

  @override
  State<MeasuresSlideBlockItem> createState() => _MeasuresSlideBlockItemState();
}

class _MeasuresSlideBlockItemState extends State<MeasuresSlideBlockItem> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      dense: true,
      title: Text(widget.measure.name),
      subtitle: Text(widget.measure.unit),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkResponse(
            onTap: widget.onTap,
            child: Icon(Icons.settings, color: colorScheme.primary.withOpacity(.75)),
          ),
        ],
      ),
    );
  }
}
