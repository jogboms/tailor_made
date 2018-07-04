import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureListItem extends StatelessWidget {
  final MeasureModel item;

  MeasureListItem(this.item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.grey[100].withOpacity(.5),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      margin: const EdgeInsets.symmetric(vertical: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(item.name, style: ralewayMedium(14.0, titleBaseColor)),
                SizedBox(height: 2.0),
                Text(item.type, style: ralewayMedium(12.0, textBaseColor)),
              ],
            ),
          ),
          Text("${item.value} ", style: ralewayRegular(16.0, titleBaseColor)),
          Text(item.unit, style: ralewayLight(12.0, titleBaseColor)),
        ],
      ),
    );
  }
}
