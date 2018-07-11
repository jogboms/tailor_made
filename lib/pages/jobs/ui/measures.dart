import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
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
        brightness: Brightness.light,
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

    return ListView.separated(
      itemCount: measurements.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 96.0),
      itemBuilder: (context, index) => MeasureListItem(measurements[index]),
      separatorBuilder: (BuildContext context, int index) => new Divider(),
    );
  }
}
