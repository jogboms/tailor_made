import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/jobs/ui/measure_list_item.dart';
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
        new Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
          child: Text("MEASUREMENTS", style: ralewayRegular(12.0, Colors.black87)),
        ),
      ]..addAll(
          measurements.where((item) => item.value.isNotEmpty).map((item) => new MeasureListItem(item)).toList(),
        ),
    );
  }
}
