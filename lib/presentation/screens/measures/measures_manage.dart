import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/measures_slide_block.dart';

class MeasuresManagePage extends StatefulWidget {
  const MeasuresManagePage({super.key});

  @override
  State<MeasuresManagePage> createState() => _MeasuresManagePageState();
}

class _MeasuresManagePageState extends State<MeasuresManagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: Text('Measurements')),
      body: ViewModelSubscriber<AppState, MeasuresViewModel>(
        converter: MeasuresViewModel.new,
        builder: (_, __, MeasuresViewModel vm) {
          if (vm.isLoading) {
            return const Center(child: LoadingSpinner());
          }

          if (vm.model.isEmpty) {
            return const Center(child: EmptyResultView(message: 'No measurements available'));
          }

          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    padding: const EdgeInsets.all(16),
                    child: const Text('Long-Press on any group to see more actions.'),
                  ),
                  for (int i = 0; i < vm.grouped.length; i++)
                    MeasureSlideBlock(
                      groupName: vm.grouped.keys.elementAt(i),
                      measures: vm.grouped.values.elementAt(i),
                      userId: vm.userId,
                    ),
                  const SizedBox(height: 72.0)
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Group'),
        onPressed: () => context.registry.get<MeasuresCoordinator>().toCreateMeasures(),
      ),
    );
  }
}
