import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'widgets/measure_list_item.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({super.key, this.measurements});

  final Map<String, double>? measurements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black87),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ViewModelSubscriber<AppState, MeasuresViewModel>(
        converter: MeasuresViewModel.new,
        builder: (BuildContext context, _, MeasuresViewModel vm) {
          if (vm.model!.isEmpty) {
            return const Center(
              child: EmptyResultView(message: 'No measurements available'),
            );
          }

          return ListView.separated(
            itemCount: vm.model!.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 96.0),
            itemBuilder: (_, int index) {
              final MeasureModel measure = vm.model![index];
              final double value = measurements![measure.id] ?? 0.0;
              return MeasureListItem(item: measure.copyWith(value: value));
            },
            separatorBuilder: (_, __) => const Divider(),
          );
        },
      ),
    );
  }
}
