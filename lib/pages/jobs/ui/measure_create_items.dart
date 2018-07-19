import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/pages/jobs/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureCreateItems extends StatelessWidget {
  final List<MeasureModel> measurements;

  const MeasureCreateItems(this.measurements);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new SlideDownItem(
          title: MeasureModelType.blouse,
          body: new JobMeasureBlock(
            measurements
                .where((measure) => measure.type == MeasureModelType.blouse)
                .toList(),
          ),
          isExpanded: true,
        ),
        new SlideDownItem(
          title: MeasureModelType.trouser,
          body: new JobMeasureBlock(
            measurements
                .where((measure) => measure.type == MeasureModelType.trouser)
                .toList(),
          ),
        ),
        new SlideDownItem(
          title: MeasureModelType.skirts,
          body: new JobMeasureBlock(
            measurements
                .where((measure) => measure.type == MeasureModelType.skirts)
                .toList(),
          ),
        ),
        new SlideDownItem(
          title: MeasureModelType.gown,
          body: new JobMeasureBlock(
            measurements
                .where((measure) => measure.type == MeasureModelType.gown)
                .toList(),
          ),
        ),
      ],
    );
  }
}

class JobMeasureBlock extends StatelessWidget {
  final List<MeasureModel> list;

  const JobMeasureBlock(this.list);

  @override
  Widget build(BuildContext context) {
    final length = list.length;
    return Theme(
      data: ThemeData(primaryColor: kPrimaryColor),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: TMBorderSide(),
          ),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: list.map((MeasureModel measure) {
            final index = list.indexOf(measure);
            return new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final removeBorder =
                    (length % 2 != 0 && (index == length - 1)) ||
                        (length % 2 == 0 &&
                            (index == length - 1 || index == length - 2));
                return new Container(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: TMBorderSide(
                        style:
                            removeBorder ? BorderStyle.none : BorderStyle.solid,
                      ),
                      right: TMBorderSide(
                        style: index % 2 == 0
                            ? BorderStyle.solid
                            : BorderStyle.none,
                      ),
                    ),
                  ),
                  width: constraints.maxWidth / 2,
                  child: TextFormField(
                    initialValue: measure.value != null && measure.value > 0
                        ? measure.value.toString()
                        : "",
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    decoration: new InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      labelText: measure.name,
                      border: InputBorder.none,
                      labelStyle: TextStyle(fontSize: 14.0),
                    ),
                    onFieldSubmitted: (value) =>
                        measure.value = double.tryParse(value),
                    onSaved: (value) => measure.value = double.tryParse(value),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
