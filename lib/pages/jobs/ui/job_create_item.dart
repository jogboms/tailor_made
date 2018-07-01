import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/jobs/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobMeasures extends StatelessWidget {
  final JobModel job;

  JobMeasures(this.job);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new SlideDownItem(
          title: MeasureModelType.blouse,
          body: new JobMeasureBlock(
            job.measurements.where((measure) => measure.type == MeasureModelType.blouse).toList(),
          ),
          // isExpanded: true,
        ),
        new SlideDownItem(
          title: MeasureModelType.trouser,
          body: new JobMeasureBlock(
            job.measurements.where((measure) => measure.type == MeasureModelType.trouser).toList(),
          ),
        ),
        new SlideDownItem(
          title: MeasureModelType.skirts,
          body: new JobMeasureBlock(
            job.measurements.where((measure) => measure.type == MeasureModelType.skirts).toList(),
          ),
        ),
        new SlideDownItem(
          title: MeasureModelType.gown,
          body: new JobMeasureBlock(
            job.measurements.where((measure) => measure.type == MeasureModelType.gown).toList(),
          ),
        ),
      ],
    );
  }
}

class JobMeasureBlock extends StatelessWidget {
  final List<MeasureModel> list;

  JobMeasureBlock(this.list);

  @override
  Widget build(BuildContext context) {
    int length = list.length;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderSideColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: list.map((MeasureModel measure) {
          int index = list.indexOf(measure);
          return new LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final removeBorder = (length % 2 != 0 && (index == length - 1)) || (length % 2 == 0 && (index == length - 1 || index == length - 2));
              return new Container(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: borderSideColor,
                      width: 1.0,
                      style: removeBorder ? BorderStyle.none : BorderStyle.solid,
                    ),
                    right: BorderSide(
                      color: borderSideColor,
                      width: 1.0,
                      style: index % 2 == 0 ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                ),
                width: constraints.maxWidth / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(measure.name, style: TextStyle(fontSize: 12.0)),
                    new TextFormField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Enter Value",
                        border: InputBorder.none,
                        hintStyle: TextStyle(fontSize: 12.0),
                      ),
                      onSaved: (value) => measure.value = value,
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
