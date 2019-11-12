import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MeasureListItem extends StatelessWidget {
  const MeasureListItem({Key key, @required this.item}) : super(key: key);

  final MeasureModel item;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return Container(
      color: Colors.grey[100].withOpacity(.5),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.name, style: theme.body3),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                  child: Text(item.group.toLowerCase(), style: theme.xsmall.copyWith(color: Colors.white)),
                  decoration: BoxDecoration(
                    color: kAccentColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            ),
          ),
          if (item.value != null && item.value > 0) ...[
            Text("${item.value} ", style: theme.subhead3.copyWith(color: kAccentColor)),
            const SizedBox(width: 2.0),
            Text(item.unit, style: theme.small.copyWith(color: kTitleBaseColor)),
          ],
          if (item.value == null || item.value == 0)
            Text("N/A", style: theme.smallLight.copyWith(color: kTitleBaseColor)),
        ],
      ),
    );
  }
}
