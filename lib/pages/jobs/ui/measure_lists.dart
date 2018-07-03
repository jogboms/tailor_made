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
    final TMTheme theme = TMTheme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text("Measurements", style: theme.titleStyle, textAlign: TextAlign.start),
        ),
        const SizedBox(height: 4.0),
      ]..addAll(
          measurements.where((item) => item.value.isNotEmpty).map((item) => new MeasureListItem(item)).toList(),
        ),
    );
  }
}
