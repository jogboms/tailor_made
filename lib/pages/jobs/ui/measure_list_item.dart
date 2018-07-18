import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureListItem extends StatelessWidget {
  final MeasureModel item;

  const MeasureListItem(this.item);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.name, style: ralewayRegular(13.0, Colors.black87)),
            SizedBox(height: 2.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
              child: Text(item.type.toLowerCase(), style: ralewayRegular(10.0, Colors.white)),
              decoration: BoxDecoration(
                color: kAccentColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ],
        ),
      ),
    ];

    if (item.value != null && item.value > 0) {
      children.addAll([
        Text("${item.value} ", style: ralewayRegular(16.0, kAccentColor)),
        SizedBox(width: 2.0),
        Text(item.unit, style: ralewayLight(12.0, kTitleBaseColor)),
      ]);
    } else {
      children.add(Text("N/A", style: ralewayLight(12.0, kTitleBaseColor)));
    }

    return new Container(
      color: Colors.grey[100].withOpacity(.5),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      ),
    );
  }
}
