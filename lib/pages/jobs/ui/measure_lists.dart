import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/jobs/ui/measure_list_item.dart';
import 'package:tailor_made/pages/jobs/ui/measures.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureLists extends StatelessWidget {
  final List<MeasureModel> measurements;

  MeasureLists({
    Key key,
    @required this.measurements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 16.0),
            Expanded(child: Text("MEASUREMENTS", style: ralewayRegular(12.0, Colors.black87))),
            CupertinoButton(
              child: Text("SHOW ALL", style: ralewayRegular(11.0, textBaseColor)),
              onPressed: () => TMNavigate(context, MeasuresPage(measurements: measurements), fullscreenDialog: true),
            ),
          ],
        )
      ]..addAll(
          measurements
              .where((item) => item.value > 0)
              .take(5)
              .map(
                (item) => new MeasureListItem(item),
              )
              .toList(),
        ),
    );
  }
}
