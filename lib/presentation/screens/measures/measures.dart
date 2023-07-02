import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/measure_list_item.dart';

class MeasuresPage extends StatelessWidget {
  const MeasuresPage({super.key, required this.measurements});

  final Map<String, double> measurements;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        systemOverlayStyle: Theme.of(context).brightness.systemOverlayStyle,
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(measurementsProvider).when(
              skipLoadingOnReload: true,
              data: (MeasurementsState state) {
                if (state.measures.isEmpty) {
                  return const Center(
                    child: EmptyResultView(message: 'No measurements available'),
                  );
                }

                return ListView.separated(
                  itemCount: state.measures.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (_, int index) {
                    final MeasureEntity measure = state.measures[index];
                    return MeasureListItem(item: measure, value: measurements[measure.id] ?? 0.0);
                  },
                  separatorBuilder: (_, __) => const Divider(),
                );
              },
              error: ErrorView.new,
              loading: () => child!,
            ),
        child: const Center(child: LoadingSpinner()),
      ),
    );
  }
}
