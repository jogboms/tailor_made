import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/redux/view_models/measures.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/measures/ui/measure_list_item.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({
    Key key,
    this.measurements,
  }) : super(key: key);

  final Map<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MeasuresViewModel>(
      converter: (store) => MeasuresViewModel(store),
      builder: (BuildContext context, vm) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black87),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          body: getBody(vm.measures),
        );
      },
    );
  }

  Widget getBody(List<MeasureModel> measures) {
    if (measures.isEmpty) {
      return Center(
        child: const EmptyResultView(message: "No measurements available"),
      );
    }

    return ListView.separated(
      itemCount: measures.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 96.0),
      itemBuilder: (context, index) {
        final measure = measures[index];
        final _value = measurements[measure.id] ?? 0.0;
        return MeasureListItem(measure..value = _value);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
