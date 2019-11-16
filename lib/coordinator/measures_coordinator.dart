import 'package:flutter/material.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/screens/measures/_partials/measure_create_item.dart';
import 'package:tailor_made/screens/measures/measures.dart';
import 'package:tailor_made/screens/measures/measures_create.dart';
import 'package:tailor_made/screens/measures/measures_manage.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class MeasuresCoordinator extends CoordinatorBase {
  const MeasuresCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  void toMeasures(Map<String, double> measures) {
    navigator?.push<void>(MkNavigate.slideIn(MeasuresPage(measurements: measures), fullscreenDialog: true));
  }

  void toManageMeasures() {
    navigator?.push<void>(MkNavigate.slideIn(const MeasuresManagePage()));
  }

  void toCreateMeasures([String groupName, String unitValue, List<MeasureModel> measures]) {
    navigator?.push<void>(MkNavigate.slideIn(
      MeasuresCreate(groupName: groupName, unitValue: unitValue, measures: measures),
      fullscreenDialog: true,
    ));
  }

  Future<MeasureModel> toCreateMeasureItem([String groupName, String unitValue, List<MeasureModel> measures]) {
    return navigator?.push<MeasureModel>(
      MkNavigate.fadeIn(MeasureCreateItem(groupName: groupName, unitValue: unitValue)),
    );
  }
}
