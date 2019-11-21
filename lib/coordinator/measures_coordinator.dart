import 'package:built_collection/built_collection.dart';
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

  void toMeasures(BuiltMap<String, double> measures) {
    navigator?.push<void>(MkNavigate.slideIn(MeasuresPage(measurements: measures), fullscreenDialog: true));
  }

  void toManageMeasures(String userId) {
    navigator?.push<void>(MkNavigate.slideIn(MeasuresManagePage(userId: userId)));
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
