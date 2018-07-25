import 'package:flutter/material.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/ui/slide_down.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class MeasureCreateItems extends StatelessWidget {
  final Map<String, List<MeasureModel>> grouped;
  final Map<String, double> measurements;

  const MeasureCreateItems(
    this.grouped,
    this.measurements,
  );

  @override
  Widget build(BuildContext context) {
    final slides = <SlideDownItem>[];

    grouped.forEach((key, data) {
      slides.add(new SlideDownItem(
        title: key,
        body: new JobMeasureBlock(
          data.toList(),
        ),
        // isExpanded: true,
      ));
    });

    return Column(
      children: slides.toList(),
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
