import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/measure.model.dart';
import 'package:tailor_made/pages/jobs/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobMeasures extends StatelessWidget {
  JobMeasures(dynamic job);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new SlideDownItem(
          title: "Blouse",
          body: new JobMeasureBlock([
            MeasureModel(name: "Arm Hole"),
            MeasureModel(name: "Shoulder"),
            MeasureModel(name: "Burst"),
            MeasureModel(name: "Burst Point"),
            MeasureModel(name: "Shoulder - Burst Point"),
            MeasureModel(name: "Shoulder - Under Burst"),
            MeasureModel(name: "Shoulder - Waist"),
          ]),
          // isExpanded: true,
        ),
        new SlideDownItem(
          title: "Trouser",
          body: new JobMeasureBlock([
            MeasureModel(name: "Length"),
            MeasureModel(name: "Waist"),
            MeasureModel(name: "Crouch"),
            MeasureModel(name: "Thigh"),
            MeasureModel(name: "Body Rise"),
            MeasureModel(name: "Width"),
            MeasureModel(name: "Hip"),
          ]),
        ),
        new SlideDownItem(
          title: "Skirts",
          body: new JobMeasureBlock([
            MeasureModel(name: "Full Length"),
            MeasureModel(name: "Short Length"),
            MeasureModel(name: "Knee Length"),
            MeasureModel(name: "Hip"),
          ]),
        ),
        new SlideDownItem(
          title: "Gown",
          body: new JobMeasureBlock([
            MeasureModel(name: "Waist"),
            MeasureModel(name: "Long Length"),
            MeasureModel(name: "Short Length"),
            MeasureModel(name: "Knee Length"),
          ]),
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
