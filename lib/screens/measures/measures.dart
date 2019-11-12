import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/measures/view_model.dart';
import 'package:tailor_made/screens/measures/_partials/measure_list_item.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({Key key, this.measurements}) : super(key: key);

  final Map<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ViewModelSubscriber<AppState, MeasuresViewModel>(
        converter: (store) => MeasuresViewModel(store),
        builder: (BuildContext context, _, MeasuresViewModel vm) {
          if (vm.model.isEmpty) {
            return const Center(
              child: EmptyResultView(message: "No measurements available"),
            );
          }

          return ListView.separated(
            itemCount: vm.model.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 96.0),
            itemBuilder: (_, index) {
              final measure = vm.model[index].toBuilder();
              final _value = measurements[measure.id] ?? 0.0;
              return MeasureListItem(item: (measure..value = _value).build());
            },
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
