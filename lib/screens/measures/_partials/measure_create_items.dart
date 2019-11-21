import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/screens/measures/_views/slide_down.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class MeasureCreateItems extends StatelessWidget {
  const MeasureCreateItems({Key key, @required this.grouped, @required this.measurements}) : super(key: key);

  final Map<String, List<MeasureModel>> grouped;
  final MapBuilder<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (var i = 0; i < grouped.length; i++)
        SlideDownItem(
          title: grouped.keys.elementAt(i),
          body: _JobMeasureBlock(
            measures: grouped.values.elementAt(i),
            measurements: measurements,
          ),
        ),
    ]);
  }
}

class _JobMeasureBlock extends StatelessWidget {
  const _JobMeasureBlock({Key key, @required this.measures, @required this.measurements}) : super(key: key);

  final List<MeasureModel> measures;
  final MapBuilder<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        children: measures.map((MeasureModel measure) {
          measurements..update((b) => b..putIfAbsent(measure.id, () => 0.0));
          return _Item(
            measure: measure,
            index: measures.indexOf(measure),
            length: measures.length,
            value: measurements[measure.id],
            onSaved: _updateMeasure,
          );
        }).toList(),
      ),
    );
  }

  void _updateMeasure(MeasureModel measure, String value) {
    measurements..update((b) => b..updateValue(measure.id, (_) => double.tryParse(value)));
    print(measurements[measure.id]);
  }
}

class _Item extends StatefulWidget {
  const _Item({Key key, this.measure, this.value, this.index, this.length, this.onSaved}) : super(key: key);

  final MeasureModel measure;
  final num value;
  final int index;
  final int length;
  final Function(MeasureModel measure, String value) onSaved;

  @override
  __ItemState createState() => __ItemState();
}

class __ItemState extends State<_Item> {
  TextEditingController _controller;
  bool _shouldRemoveBottomBorder;
  bool _shouldRemoveRightBorder;

  @override
  void initState() {
    final _value = widget.value != null && widget.value > 0 ? widget.value.toString() : "";
    _controller = TextEditingController(text: _value);
    final isOdd = widget.length % 2 != 0;
    final isLast = widget.index == widget.length - 1;
    final isLastOrBeforeLast = isLast || widget.index == widget.length - 2;
    _shouldRemoveBottomBorder = (isOdd && isLast) || (!isOdd && isLastOrBeforeLast);
    _shouldRemoveRightBorder = widget.index % 2 != 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: _shouldRemoveBottomBorder ? BorderSide.none : MkBorderSide(),
              right: _shouldRemoveRightBorder ? BorderSide.none : MkBorderSide(),
            ),
          ),
          width: constraints.maxWidth / 2,
          child: TextFormField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: ThemeProvider.of(context).headline,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              labelText: widget.measure.name,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
            onFieldSubmitted: (value) => widget.onSaved(widget.measure, value),
            onSaved: (value) => widget.onSaved(widget.measure, value),
          ),
        );
      },
    );
  }
}
