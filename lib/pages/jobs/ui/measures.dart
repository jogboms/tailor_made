import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/jobs/ui/measure_list_item.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class MeasuresPage extends StatelessWidget {
  final List<MeasureModel> measurements;

  MeasuresPage({
    Key key,
    this.measurements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: getBody(),
    );
  }

  getBody() {
    if (measurements.isEmpty) {
      return Center(
        child: TMEmptyResult(message: "No measurements available"),
      );
    }

    return ListView(
      children: measurements.map((item) => MeasureListItem(item)).toList(),
    );
  }
}
