import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/measures/measures.dart';
import '../screens/measures/measures_create.dart';
import '../screens/measures/measures_manage.dart';
import '../screens/measures/widgets/measure_create_item.dart';
import 'coordinator_base.dart';

@immutable
class MeasuresCoordinator extends CoordinatorBase {
  const MeasuresCoordinator(super.navigatorKey);

  void toMeasures(Map<String, double> measures) {
    navigator?.push<void>(RouteTransitions.slideIn(MeasuresPage(measurements: measures), fullscreenDialog: true));
  }

  void toManageMeasures(String userId) {
    navigator?.push<void>(RouteTransitions.slideIn(MeasuresManagePage(userId: userId)));
  }

  void toCreateMeasures({
    MeasureGroup? groupName,
    String? unitValue,
    List<MeasureEntity>? measures,
  }) {
    navigator?.push<void>(
      RouteTransitions.slideIn(
        MeasuresCreate(groupName: groupName, unitValue: unitValue, measures: measures),
        fullscreenDialog: true,
      ),
    );
  }

  Future<DefaultMeasureEntity?>? toCreateMeasureItem({
    MeasureGroup? groupName,
    String? unitValue,
  }) {
    return navigator?.push<DefaultMeasureEntity>(
      RouteTransitions.fadeIn(MeasureCreateItem(groupName: groupName, unitValue: unitValue)),
    );
  }
}
