import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';

class MeasureListItem extends StatelessWidget {
  const MeasureListItem({super.key, required this.item, required this.value});

  final MeasureEntity item;
  final double value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      color: Colors.grey[100]!.withOpacity(.5),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.name, style: theme.body3),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    item.group.displayName.toLowerCase(),
                    style: theme.xsmall.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          if (value > 0) ...<Widget>[
            Text('$value ', style: theme.subhead3.copyWith(color: kAccentColor)),
            const SizedBox(width: 2.0),
            Text(item.unit, style: theme.small.copyWith(color: kTitleBaseColor)),
          ],
          if (value == 0) Text('N/A', style: theme.smallLight.copyWith(color: kTitleBaseColor)),
        ],
      ),
    );
  }
}
