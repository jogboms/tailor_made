import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'widgets/measures_slide_block.dart';

class MeasuresManagePage extends StatefulWidget {
  const MeasuresManagePage({super.key});

  @override
  State<MeasuresManagePage> createState() => _MeasuresManagePageState();
}

class _MeasuresManagePageState extends State<MeasuresManagePage> {
  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: Text(l10n.measurementsPageTitle)),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(measurementsProvider).when(
              skipLoadingOnReload: true,
              data: (MeasurementsState state) {
                if (state.measures.isEmpty) {
                  return Center(child: EmptyResultView(message: l10n.noMeasurementsAvailableMessage));
                }

                return SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).colorScheme.outlineVariant,
                          padding: const EdgeInsets.all(16),
                          child: Text(l10n.measurementGroupInfoMessage),
                        ),
                        for (int i = 0; i < state.grouped.length; i++)
                          MeasureSlideBlock(
                            groupName: state.grouped.keys.elementAt(i),
                            measures: state.grouped.values.elementAt(i),
                            userId: state.userId,
                          ),
                        const SizedBox(height: 72.0)
                      ],
                    ),
                  ),
                );
              },
              error: ErrorView.new,
              loading: () => child!,
            ),
        child: const Center(child: LoadingSpinner()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.addMeasurementGroupCaption),
        onPressed: () => context.router.toCreateMeasures(),
      ),
    );
  }
}
