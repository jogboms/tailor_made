import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/measures.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/measures/_partials/measure_list_item.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({
    Key key,
    this.measurements,
  }) : super(key: key);

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
        builder: (
          BuildContext context,
          DispatchFunction dispatcher,
          MeasuresViewModel vm,
        ) {
          if (vm.model.isEmpty) {
            return const Center(
              child: const EmptyResultView(
                message: "No measurements available",
              ),
            );
          }

          return ListView.separated(
            itemCount: vm.model.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) {
              final measure = vm.model[index];
              final _value = measurements[measure.id] ?? 0.0;
              return MeasureListItem(item: measure..value = _value);
            },
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
