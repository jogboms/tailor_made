import 'dart:async';

import 'package:injector/injector.dart';
import 'package:tailor_made/models/stats.dart';

abstract class Stats {
  static Stats di() {
    return Injector.appInstance.getDependency<Stats>();
  }

  Stream<StatsModel> fetch();
}
