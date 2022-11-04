import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/screens/measures/_views/slide_down.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MeasureCreateItems extends StatelessWidget {
  const MeasureCreateItems({super.key, required this.grouped, required this.measurements});

  final Map<String, List<MeasureModel>>? grouped;
  final Map<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        for (int i = 0; i < grouped!.length; i++)
          SlideDownItem(
            title: grouped!.keys.elementAt(i),
            body: JobMeasureBlock(
              measures: grouped!.values.elementAt(i),
              measurements: measurements,
            ),
          ),
      ],
    );
  }
}

// TODO(Jogboms): should rework this
class JobMeasureBlock extends StatelessWidget {
  const JobMeasureBlock({super.key, required this.measures, required this.measurements});

  final List<MeasureModel> measures;
  final Map<String, double?> measurements;

  @override
  Widget build(BuildContext context) {
    final int length = measures.length;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: measures.map((MeasureModel measure) {
          final int index = measures.indexOf(measure);

          final num? value1 = measurements.containsKey(measure.id) ? measurements[measure.id] : 0;
          final String value = value1 != null && value1 > 0 ? value1.toString() : '';
          final TextEditingController controller = TextEditingController(text: value);

          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool removeBorder = (length % 2 != 0 && (index == length - 1)) ||
                  (length.isEven && (index == length - 1 || index == length - 2));
              return Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: MkBorderSide(
                      style: removeBorder ? BorderStyle.none : BorderStyle.solid,
                    ),
                    right: MkBorderSide(
                      style: index.isEven ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                ),
                width: constraints.maxWidth / 2,
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: ThemeProvider.of(context)!.headline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: measure.name,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                  ),
                  onFieldSubmitted: (String value) => measurements[measure.id] = double.tryParse(value),
                  onSaved: (String? value) => measurements[measure.id] = double.tryParse(value!),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
